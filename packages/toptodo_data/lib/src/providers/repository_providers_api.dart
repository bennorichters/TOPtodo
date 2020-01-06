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

  Future<TdBranch> tdBranch({
    @required String id,
  });
  Future<Iterable<TdBranch>> tdBranches({
    @required String startsWith,
  });

  Future<TdCaller> tdCaller({
    @required String id,
  });
  Future<Iterable<TdCaller>> tdCallers({
    @required String startsWith,
    @required TdBranch tdBranch,
  });

  Future<TdCategory> tdCategory({
    @required String id,
  });
  Future<Iterable<TdCategory>> tdCategories();

  Future<TdSubCategory> tdSubCategory({
    @required String id,
  });
  Future<Iterable<TdSubCategory>> tdSubCategories({
    @required TdCategory tdCategory,
  });

  Future<TdDuration> tdDuration({
    @required String id,
  });
  Future<Iterable<TdDuration>> tdDurations();

  Future<TdOperator> tdOperator({
    @required String id,
  });
  Future<TdOperator> currentTdOperator();
  Future<Iterable<TdOperator>> tdOperators({
    @required String startsWith,
  });

  Future<String> createIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  });
}
