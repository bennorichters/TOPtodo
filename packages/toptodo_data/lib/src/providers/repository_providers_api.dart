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

  Future<Operator> fetchCurrentOperator();

  Future<Iterable<Branch>> fetchBranches({
    @required String startsWith,
  });
  Future<Iterable<IncidentDuration>> fetchDurations();
  Future<Iterable<Category>> fetchCategories();
  Future<Iterable<SubCategory>> fetchSubCategories({
    @required Category category,
  });
  Future<Iterable<Operator>> fetchOperators({
    @required String startsWith,
  });
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required Branch branch,
  });
}
