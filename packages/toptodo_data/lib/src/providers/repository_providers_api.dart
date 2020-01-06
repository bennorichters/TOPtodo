import 'package:meta/meta.dart';

import 'package:toptodo_data/src/models/credentials.dart';
import 'package:toptodo_data/src/models/settings.dart';
import 'package:toptodo_data/src/models/topdesk_elements.dart';

abstract class CredentialsProvider {
  Future<Credentials> provide();
  Future<void> save(Credentials credentials);
  Future<void> delete();
}

abstract class SettingsProvider {
  void init(String url, String loginName);
  void dispose();
  Future<Settings> provide();
  Future<void> save(Settings settings);
  Future<void> delete();
}

abstract class TopdeskProvider {
  void init(Credentials credentials);
  void dispose();

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
  Future<Iterable<IncidentOperator>> incidentOperators({
    @required String startsWith,
  });

  Future<String> createIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  });
}
