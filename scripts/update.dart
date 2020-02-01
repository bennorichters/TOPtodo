import 'dart:io';

void main() {
  final currentDir = Directory.current.path;

  upgrade(currentDir, 'toptodo_data');
  upgrade(currentDir, 'toptodo_local_storage');
  upgrade(currentDir, 'toptodo_topdesk_api');
  upgrade(currentDir, 'toptodo_topdesk_test_data');
  upgrade(currentDir, 'toptodo_backend');
}

void upgrade(String currentDir, String packageName) {
  Directory.current = Directory('$currentDir/packages/$packageName');
  Process.run('pub', ['upgrade']).then((ProcessResult pr) {
    print(pr.exitCode);
    print(pr.stdout);
    print(pr.stderr);
  });
}
