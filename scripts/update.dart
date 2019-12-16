import 'dart:io';

void main() {
  final String currentDir = Directory.current.path;

  upgrade(currentDir, 'toptodo_data');
  upgrade(currentDir, 'toptodo_repository_providers_impl');
  upgrade(currentDir, 'toptodo_topdesk_provider_api');
  upgrade(currentDir, 'toptodo_topdesk_provider_mock');
}

void upgrade(String currentDir, String packageName) {
  Directory.current = Directory('$currentDir/packages/$packageName');
  Process.run('pub', <String>['upgrade']).then((ProcessResult pr) {
    print(pr.exitCode);
    print(pr.stdout);
    print(pr.stderr);
  });
}
