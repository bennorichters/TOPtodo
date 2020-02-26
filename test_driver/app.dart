import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:toptodo/toptodo_app.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_test_data/toptodo_topdesk_test_data.dart';

void main() {
  final topdeskProvider = _TestFakeTopdeskProvider();

  enableFlutterDriverExtension(handler: (request) async {
    switch (request) {
      case 'lastBriefdescription':
        return topdeskProvider.lastBriefDescription;
      case 'lastRequest':
        return topdeskProvider.lastRequest;
      case 'lastSettings':
        return topdeskProvider.lastSettings.toJson().toString();
      default:
        return null;
    }
  });

  runApp(
    TopToDoApp(
      credentialsProvider: _TestCredentialsProvider(),
      settingsProvider: _TestSettingsProvider(),
      topdeskProvider: topdeskProvider,
    ),
  );
}

class _TestFakeTopdeskProvider extends FakeTopdeskProvider {
  String lastBriefDescription;
  String lastRequest;
  Settings lastSettings;

  @override
  Future<String> createTdIncident({
    String briefDescription,
    String request,
    Settings settings,
  }) {
    lastBriefDescription = briefDescription;
    lastRequest = request;
    lastSettings = settings;

    return super.createTdIncident(
      briefDescription: briefDescription,
      request: request,
      settings: settings,
    );
  }
}

class _TestCredentialsProvider implements CredentialsProvider {
  Credentials _credentials = Credentials();

  @override
  Future<void> delete() => Future.value();

  @override
  Future<Credentials> provide() => Future.value(_credentials);
  @override
  Future<void> save(Credentials credentials) {
    _credentials = credentials;
    return Future.value();
  }
}

class _TestSettingsProvider implements SettingsProvider {
  Settings _settings = Settings();

  @override
  Future<void> delete() => Future.value();

  @override
  void dispose() {}

  @override
  void init(String url, String loginName) {}

  @override
  Future<Settings> provide() => Future.value(_settings);

  @override
  Future<void> save(Settings settings) {
    _settings = settings;
    return Future.value();
  }
}
