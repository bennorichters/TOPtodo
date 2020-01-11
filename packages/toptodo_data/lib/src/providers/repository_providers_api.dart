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

  /// Returns instances of [TdCategory] representing all categories for
  /// incidents in TOPdesk.
  Future<Iterable<TdCategory>> tdCategories();

  /// Returns the [TdSubcategory] with the given `id`
  Future<TdSubcategory> tdSubcategory({
    @required String id,
  });

  /// Returns instances of [TdSubcategory] representing all subcategories in
  /// TOPdesk that belong to the given `tdCategory`.
  Future<Iterable<TdSubcategory>> tdSubcategories({
    @required TdCategory tdCategory,
  });

  /// Returns the [TdDuration] with the given `id`
  Future<TdDuration> tdDuration({
    @required String id,
  });

  /// Returns instances of [TdCategory] representing all durations for
  /// incidents in TOPdesk.
  Future<Iterable<TdDuration>> tdDurations();

  /// Returns the [TdOperator] with the given `id`
  Future<TdOperator> tdOperator({
    @required String id,
  });

  /// Returns the [TdOperator] belonging to the [Credentials] that where used
  /// in the [init()] of this provider.
  Future<TdOperator> currentTdOperator();

  /// Returns the first x [TdOperator]s whose names start with `startsWith`,
  /// where x depends on the implementation.
  Future<Iterable<TdOperator>> tdOperators({
    @required String startsWith,
  });

  /// Creates a new incident in TOPdesk and returns the new incident number.
  Future<String> createTdIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  });
}
