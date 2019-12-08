import 'package:meta/meta.dart';

import '../models/credentials.dart';
import '../models/settings.dart';
import '../models/topdesk_elements.dart';

abstract class CredentialsProvider {
  Future<Credentials> provide();
  Future<void> save(Credentials credentials);
}

abstract class SettingsProvider {
  void init(String url, String loginName);
  Future<Settings> provide();
  Future<void> save(Settings settings);
}

abstract class TopdeskProvider {
  void init(Credentials credentials);

  Future<Iterable<Branch>> branches({
    @required String startsWith,
  });
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  });
  Future<Operator> currentOperator();
  Future<Iterable<IncidentDuration>> durations();
  Future<Iterable<Category>> categories();
  Future<Iterable<SubCategory>> subCategories({
    @required Category category,
  });
  Future<Iterable<Operator>> operators({
    @required String startsWith,
  });
}
