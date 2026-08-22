import 'dart:io';

/// [ARCH: PRESENTATION]
/// ROLE: Writes Markdown to the user Downloads folder (desktop / mobile).
Future<String> saveTextFile({
  required String filename,
  required String contents,
}) async {
  final home =
      Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      Directory.systemTemp.path;
  final downloads = Directory('$home${Platform.pathSeparator}Downloads');
  final dir = downloads.existsSync() ? downloads : Directory.systemTemp;
  final file = File('${dir.path}${Platform.pathSeparator}$filename');
  await file.writeAsString(contents);
  return file.path;
}
