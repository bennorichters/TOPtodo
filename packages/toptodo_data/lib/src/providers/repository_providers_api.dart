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

  Future<Branch> branch({
    @required String id,
  });
  Future<Iterable<Branch>> branches({
    @required String startsWith,
  });

  Future<Caller> caller({
    @required String id,
  });
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  });

  Future<Category> category({
    @required String id,
  });
  Future<Iterable<Category>> categories();

  Future<SubCategory> subCategory({
    @required String id,
  });
  Future<Iterable<SubCategory>> subCategories({
    @required Category category,
  });

  Future<IncidentDuration> incidentDuration({
    @required String id,
  });
  Future<Iterable<IncidentDuration>> incidentDurations();

  Future<IncidentOperator> incidentOperator({
    @required String id,
  });
  Future<IncidentOperator> currentIncidentOperator();
  Future<Iterable<IncidentOperator>> incdentOperators({
    @required String startsWith,
  });
}
