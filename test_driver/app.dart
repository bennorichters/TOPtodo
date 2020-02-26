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
      case 'lastBranch':
        {
          final id = topdeskProvider.lastSettings.tdBranchId;
          final branch = await topdeskProvider.tdBranch(id: id);
          return branch.name;
        }
      case 'lastCaller':
        {
          final id = topdeskProvider.lastSettings.tdCallerId;
          final caller = await topdeskProvider.tdCaller(id: id);
          return caller.name;
        }
      case 'lastCategory':
        {
          final id = topdeskProvider.lastSettings.tdCategoryId;
          final category = await topdeskProvider.tdCategory(id: id);
          return category.name;
        }
      case 'lastSubcategory':
        {
          final id = topdeskProvider.lastSettings.tdSubcategoryId;
          final subcategory = await topdeskProvider.tdSubcategory(id: id);
          return subcategory.name;
        }
      case 'lastDuration':
        {
          final id = topdeskProvider.lastSettings.tdDurationId;
          final duration = await topdeskProvider.tdDuration(id: id);
          return duration.name;
        }
      case 'lastOperator':
        {
          final id = topdeskProvider.lastSettings.tdOperatorId;
          final tdOperator = await topdeskProvider.tdOperator(id: id);
          return tdOperator.name;
        }
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
