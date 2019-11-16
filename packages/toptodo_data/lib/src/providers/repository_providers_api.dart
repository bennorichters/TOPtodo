import 'package:flutter/material.dart';

import '../models/credentials.dart';
import '../models/settings.dart';
import '../models/topdesk_elements.dart';

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

  Future<Iterable<Branch>> fetchBranches({@required String startsWith});
  Future<Iterable<IncidentDuration>> fetchDurations();
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required String branchId,
  });
}
