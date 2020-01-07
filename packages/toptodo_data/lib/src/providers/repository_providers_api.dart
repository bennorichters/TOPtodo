import 'package:meta/meta.dart';

import 'package:toptodo_data/src/models/credentials.dart';
import 'package:toptodo_data/src/models/settings.dart';
import 'package:toptodo_data/src/models/topdesk_elements.dart';

/// Provider for [Credentials]
abstract class CredentialsProvider {
  /// Returns a per user unique instance of a [Credentials]
  Future<Credentials> provide();

  /// Saves the user's [Credentials]
  Future<void> save(Credentials credentials);

  /// Deletes the user's [Credentials]
  Future<void> delete();
}

/// Provider for [Settings]
abstract class SettingsProvider {
  /// Initialiazes this provider.
  void init(String url, String loginName);

  /// Invalidates a previous call to init. Implementations can use this method
  /// to  dispose of any cached data.
  void dispose();

  /// Returns a per user and per combination of values used to [init()] this
  /// provider [Settings]
  Future<Settings> provide();

  /// Saves the user's [Settings] for the combination of values used to
  /// [init()] this provider
  Future<void> save(Settings settings);

  /// Deletes the user's [Settings] for the combination of values used to
  /// [init()] this provider
  Future<void> delete();
}

/// Provider for TOPdesk elements.
abstract class TopdeskProvider {
  /// Initializes this provider with the given [Credentials]
  void init(Credentials credentials);

  /// Invalidates a previous call to init. Implementations can use this method
  /// to  dispose of any cached data.
  void dispose();

  /// Returns the [TdBranch] with the given `id`
  Future<TdBranch> tdBranch({
    @required String id,
  });
  /// Returns the first x [TdBranch]es which names start with `startsWith`, 
  /// where x depends on the implementation.
  Future<Iterable<TdBranch>> tdBranches({
    @required String startsWith,
  });

  /// Returns the [TdCaller] with the given `id`
  Future<TdCaller> tdCaller({
    @required String id,
  });
  /// Returns the first x [TdCaller]s whose names start with `startsWith` and 
  /// belong to `tdBranch`, where x depends on the implementation.
  Future<Iterable<TdCaller>> tdCallers({
    @required String startsWith,
    @required TdBranch tdBranch,
  });

  /// Returns the [TdCategory] with the given `id`
  Future<TdCategory> tdCategory({
    @required String id,
  });
  
  Future<Iterable<TdCategory>> tdCategories();

  Future<TdSubcategory> tdSubCategory({
    @required String id,
  });
  Future<Iterable<TdSubcategory>> tdSubCategories({
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

  Future<String> createTdIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  });
}
