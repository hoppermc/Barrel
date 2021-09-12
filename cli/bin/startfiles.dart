var windows =
"""
java -jar %EXECUTABLE% --nogui
""";

var linux =
"""
java -jar %EXECUTABLE%
""";

String createWindows(String executable) {
  return windows.replaceAll("%EXECUTABLE%", executable);
}

String createLinux(String executable) {
  return linux.replaceAll("%EXECUTABLE%", executable);
}