import 'dart:io';

void main(List<String> args) async {
  if (args.length != 1) throw ArgumentError('expected exactly one argument');

  List<String> flutterOptions;
  List<String> pubOptions;
  final command = args[0];
  switch (command) {
    case 'upgrade':
      {
        flutterOptions = ['pub', 'upgrade'];
        pubOptions = ['upgrade'];
        break;
      }
    case 'test':
      {
        flutterOptions = ['test'];
        pubOptions = ['run', 'test'];
        break;
      }
    default:
      {
        throw ArgumentError('unknown command $command');
      }
  }

  final currentDir = Directory.current.path;

  Future<void> run(String name, bool flutter) async {
    print('running $command for $name');

    return await Process.run(
      flutter ? 'flutter' : 'pub',
      flutter ? flutterOptions : pubOptions,
      runInShell: true,
    ).then((ProcessResult pr) {
      print(pr.exitCode);
      print(pr.stdout);
      print(pr.stderr);
    });
  }

  Future<void> runForPackage(String packageName, [bool flutter = false]) async {
    Directory.current = Directory('$currentDir/packages/$packageName');
    return run(packageName, flutter);
  }

  Future<void> runForRoot() async {
    Directory.current = Directory(currentDir);
    return run('root', true);
  }

  await runForPackage('toptodo_data');
  await runForPackage('toptodo_local_storage', true);
  await runForPackage('toptodo_topdesk_api');
  await runForPackage('toptodo_topdesk_test_data');
  await runForPackage('toptodo_backend');
  await runForRoot();
}
