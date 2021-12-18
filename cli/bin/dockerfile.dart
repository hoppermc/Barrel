var template =
"""
FROM azul/zulu-openjdk-alpine:%JAVA_VERSION%-jre
LABEL baseimage.author="helightdev@gmail.com"
LABEL baseimage.src="https://github.com/hoppermc/Hopper"
LABEL generated.version="%VERSION%"
LABEL generated.flavour="%FLAVOUR%"

ARG server_executable=%EXECUTABLE%
ENV server_executable=\$server_executable

EXPOSE 25565/tcp

COPY ./ /runner

WORKDIR /runner
ENTRYPOINT java -jar \$server_executable
""";


String createFromTemplate(String executable, String version, String flavour, String javaVersion) {
  return template
      .replaceAll("%EXECUTABLE%", executable)
      .replaceAll("%VERSION%", version)
      .replaceAll("%FLAVOUR%", flavour)
      .replaceAll("%JAVA_VERSION%", javaVersion);
}