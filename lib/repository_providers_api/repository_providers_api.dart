import 'package:toptopdo/models/credentials.dart';
import 'package:toptopdo/models/settings.dart';
import 'package:toptopdo/models/topdesk_elements.dart';

abstract class CredentialsProvider {
  Future<Credentials> provide();
  Future<void> save(Credentials credentials);
}

typedef SettingsProviderFactory = SettingsProvider Function(
  String url,
  String loginName,
);

abstract class SettingsProvider {
  Future<Settings> provide();
  Future<void> save(Settings settings);
}

abstract class TopdeskProvider {
  void init(Credentials credentials);

  Future<Iterable<Branch>> fetchBranches(String startsWith);
  Future<Iterable<IncidentDuration>> fetchDurations();
}