import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:console/console.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:toml/toml.dart';
import 'package:uuid/uuid.dart';

import 'barrel_configuration.dart';
import 'dockerfile.dart';
import 'ignorefiles.dart';
import 'startfiles.dart';

var dio = Dio();
var uuids = Uuid();

var spigotVersions = ["1.19", "1.18.2", "1.18.1", "1.17.1", "1.16.5", "1.12.2", "1.8.8"]; //Common versions
var javaVersions =   ["17",   "17",     "17",     "16",     "16",     "16",     "16"];

var helpMessage =
"""
A command-line utility for installing and running minecraft, as well as creating dockerized minecraft-server images.

Usage: barrel <command> [arguments]
    
barrel:
    help, ?     Prints this help message.
    init        Starts the barrel initializer and creates a runnable environment in the current directory.
    run         Launches the operation system specific startfile.
      -d, --dockerized    Performs a docker build and runs the image wrapped. 
    build       Wraps a normal docker build command with default values.
    pull        Pulls the server files based on the hopper configuration.
    doctor      Snapshots and prints debug details about the current environment and image.
      -z, --nozip         Skips the zip working directory step. 
""";

void writeLine(String s) {
  Console.write("$s\n");
}

void main(List<String> arguments) async {
  Console.init();
  if (arguments.isEmpty) {
    writeLine(helpMessage);
    exit(0);
  } else {
    if (arguments.elementAt(0) == "init") {
      await init();
    } else if (arguments.elementAt(0) == "run") {
      await run(arguments.contains("--docker") || arguments.contains("-d"));
    } else if (arguments.elementAt(0) == "build") {
      await build();
    } else if (arguments.elementAt(0) == "pull") {
      await pull();
    } else if (arguments.elementAt(0) == "doctor") {
      await doctor(arguments.contains("--nozip") || arguments.contains("-z"));
    }
  }

  writeLine(helpMessage);
  exit(0);
}

Future<void> run(bool dockerized) async {
  if (!dockerized) {
    if (Platform.isWindows) {
      await runWrappedCmd("start.bat", []);
    } else if (Platform.isLinux) {
      await runCmd("chmod", ["700", "./start.sh"]);
      await runWrappedCmd("./start.sh", []);
    }
  } else {
    var buildId = uuids.v4().replaceAll("-", "");
    await build(buildId, false);
    await runWrappedCmd("docker", ["run", "-i", "-p", "25565:25565", "--rm=false", buildId]);
  }
  exit(0);
}

Future<bool> acceptEula() async {
  var working = Directory.current;
  writeLine("Please accept the minecraft eula (https://account.mojang.com/documents/minecraft_eula)");
  var isAccepted = await Prompter("[yes/no]: ").ask();
  if (isAccepted) {
    writeLine("Creating eula.txt");
    await File(working.path + "/" + "eula.txt").writeAsString("eula=true");
  }
  return isAccepted;
}

Future<BarrelConfiguration> configuration() async {
  var working = Directory.current;
  var configFile = File(working.path + "/" + "barrel.toml");
  if (!await configFile.exists()) throw Exception("barrel.toml doesn't exist in current working directory");
  var configString = await File(working.path + "/" + "barrel.toml").readAsString();
  return BarrelConfiguration.fromMap(TomlDocument.parse(configString).toMap());
}

Future<void> build([String? tagOverride, bool doExit = true]) async {
  var working = Directory.current;
  var configFile = File(working.path + "/" + "barrel.toml");
  if (!await configFile.exists()) throw Exception("barrel.toml doesn't exist in current working directory");
  var configString = await File(working.path + "/" + "barrel.toml").readAsString();
  var barrelConfiguration = BarrelConfiguration.fromMap(TomlDocument.parse(configString).toMap());
  var imageTag = (tagOverride ?? barrelConfiguration.name)!;
  await runCmd("docker", ["build", "-t", imageTag, "."]);
  writeLine("You can now reference the image via the tag '$imageTag'");
  if (doExit) exit(0);
}

Future<void> init() async {
  var working = Directory.current;
  writeLine("Starting barrel initializer at $working");
  writeLine("Please select your preferred flavour");
  var flavour =
      await Chooser(["spigot", "paper"], message: "Flavour: ").choose();
  writeLine("Please select a minecraft version");
  var version = await Chooser(spigotVersions, message: "Version: ").choose();
  var name =
      await Prompter("Please choose an image name [kebap-case/slug-case]: ")
          .prompt();

  if (!await acceptEula()) {
    writeLine("Eula hasn't been accepted. Exiting setup.");
    return;
  }
  var jarFile = "$flavour-runner.jar";
  writeLine("Creating Dockerfile");
  var javaVersion = javaVersions.elementAt(spigotVersions.indexOf(version));
  await File(working.path + "/" + "Dockerfile")
      .writeAsString(createFromTemplate(jarFile, version, flavour, javaVersion));
  writeLine("Creating plugin folder");
  await Directory(working.path + "/" + "plugins").create();
  writeLine("Creating common start files");
  await File(working.path + "/" + "start.sh")
      .writeAsString(createLinux(jarFile));
  await File(working.path + "/" + "start.bat")
      .writeAsString(createWindows(jarFile));
  writeLine("Creating .dockerignore");
  await File(working.path + "/" + ".dockerignore").writeAsString(dockerIgnore);
  writeLine("Creating .gitignore");
  await File(working.path + "/" + ".gitignore").writeAsString(gitIgnore);
  var barrelConfiguration = BarrelConfiguration(
    name: name,
    description: "a new barrel image",
    flavour: flavour,
    version: version,
  );
  writeLine("Writing default barrel.toml");
  await File(working.path + "/" + "barrel.toml").writeAsString(
      TomlDocument.fromMap(barrelConfiguration.toMap()).toString());

  await installServer(barrelConfiguration);

  ServerSocket? tempSocket;
  try {
    writeLine("Trying to bind to 25565 intentionally so that the server start will fail");
    tempSocket = await ServerSocket.bind("localhost", 25565);
  } catch (_) {
    writeLine("Can't bind to 25565 continuing anyways");
  }

  if (Platform.isWindows) {
    await runWrappedCmd("start.bat", []);
  } else if (Platform.isLinux) {
    await runCmd("chmod", ["700", "./start.sh"]);
    await runWrappedCmd("./start.sh", []);
  }

  await tempSocket?.close();
  writeLine("Setup completed!");

  exit(0);
}

Future<void> pull() async {
  var working = Directory.current;
  var configFile = File(working.path + "/" + "barrel.toml");
  if (!await configFile.exists()) throw Exception("barrel.toml doesn't exist in current working directory");
  var configString = await File(working.path + "/" + "barrel.toml").readAsString();
  var barrelConfiguration = BarrelConfiguration.fromMap(TomlDocument.parse(configString).toMap());
  await installServer(barrelConfiguration);
  exit(0);
}

Future<void> installServer(BarrelConfiguration configuration) async {
  var working = Directory.current;
  var flavour = configuration.flavour!;
  var version = configuration.version!;
  var file = File(working.path + "/" + "$flavour-runner.jar");
  switch (flavour) {
    case "spigot":
      await downloadFile(
          "https://download.getbukkit.org/spigot/spigot-$version.jar", file);
      break;
    case "paper":
      var build = await getLatestPaperBuild(version);
      await downloadFile("https://papermc.io/api/v2/projects/paper/versions/$version/builds/$build/downloads/paper-$version-$build.jar", file);
      break;
    default:
      throw Exception("Invalid server flavour");
  }
}

Future<void> doctor(bool isNozip) async {
  var working = Directory.current;
  var configFile = File(working.path + "/" + "barrel.toml");
  if (!await configFile.exists()) {
    writeLine("Barrel configuration doesn't exist!");
    exit(0);
  }
  var configString = await File(working.path + "/" + "barrel.toml").readAsString();
  var barrelConfiguration = BarrelConfiguration.fromMap(TomlDocument.parse(configString).toMap());
  var executableFile = File(working.path + "/" + "${barrelConfiguration.flavour}-runner.jar");
  if (!await executableFile.exists()) {
    writeLine("Server executable doesn't exist!");
    exit(0);
  }
  var executableHash = await sha256.bind(executableFile.openRead()).first;
  var dockerfile = await File(working.path + "/" + "Dockerfile").readAsString();

  var zipper = ZipFileEncoder();
  writeLine("Zipping current working directory...");
  zipper.zipDirectory(working, filename: "doctor.zip");
  writeLine("Saved current working directory as doctor.zip");

  writeLine("========= Begin Summary ========");
  writeLine("DartRuntime: ${Platform.version}");
  writeLine("Platform: ${Platform.operatingSystem}");
  writeLine("PlatformVersion: ${Platform.operatingSystemVersion}");
  writeLine("Processors: ${Platform.numberOfProcessors}");
  writeLine("Flavour: ${barrelConfiguration.flavour}");
  writeLine("Version: ${barrelConfiguration.version}");
  writeLine("Executable SHA256: $executableHash");
  writeLine("Docker:");
  /* Docker Version */ await runCmd("docker", ["--version"]);
  writeLine("Java:");
  /* Java Version */ await runCmd("java", ["--version"]);
  writeLine("========== Dockerfile ==========");
  writeLine(dockerfile.trimRight());
  writeLine("========== End Summary =========");
  exit(0);
}

Future<void> downloadFile(String uri, File file,
    {String? beforeMessage, String? doneMessage}) async {
  writeLine(beforeMessage ?? "Downloading $uri");
  await HttpClient()
      .getUrl(Uri.parse(uri))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) async {
    var length = response.contentLength;
    var progressBar = ProgressBar(complete: length);
    var fileSink = file.openWrite();
    var received = 0;
    progressBar.update(received);
    await response.map((event) {
      received += event.length;
      progressBar.update(received);
      return event;
    }).pipe(fileSink);
    Console.overwriteLine(
        (doneMessage ?? "Download completed " + Icon.CHECKMARK) + "\n");
  });
}

Future<void> runCmd(String cmd, List<String> args, [bool printExitCode = false]) async {
  var process = await Process.start(cmd, args);
  var s1 = process.stdout.listen(stdout.add);
  var s2 = process.stderr.listen(stderr.add);
  var exc = await process.exitCode;
  await s1.cancel();
  await s2.cancel();
  if (exc != 0) throw Exception('Process error: $exc');
  if (printExitCode) TextPen()..setColor(Color.YELLOW)..text("Process '$cmd ${args.join(" ")}' exited with error code $exc\n").print();
}

Future<void> runWrappedCmd(String cmd, List<String> args) async {
  var process = await Process.start(cmd, args);
  var s1 = process.stdout.listen(stdout.add);
  var s2 = process.stderr.listen(stderr.add);
  var s3 = stdin.listen(process.stdin.add);
  var exc = await process.exitCode;
  await s1.cancel();
  await s2.cancel();
  await s3.cancel();
  if (exc != 0) throw Exception('Process error: $exc');
  TextPen()
    ..setColor(Color.YELLOW)
    ..text("Process '$cmd ${args.join(" ")}' exited with error code $exc\n")
        .print();
}

Future<int> getLatestPaperBuild(String version) async {
  var response = await dio
      .get("https://papermc.io/api/v2/projects/paper/versions/$version");
  var latestBuild = (response.data["builds"] as List<dynamic>).last as int;
  return latestBuild;
}
