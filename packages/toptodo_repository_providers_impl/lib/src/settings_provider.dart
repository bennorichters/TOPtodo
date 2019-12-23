import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SharedPreferencesSettingsProvider extends SettingsProvider {
  SharedPreferencesSettingsProvider(this.topdeskProvider);
  final TopdeskProvider topdeskProvider;

  String _storageKey;
  Settings _value;

  @override
  void init(String url, String loginName) {
    assert(_storageKey == null, 'init has already been called');
    _storageKey = _generateMd5(url + loginName);
  }

  static String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  Future<Settings> provide() async {
    assert(_storageKey != null, 'init has not been called');

    return _value ??= await _retrieveValue();
  }

  Future<Settings> _retrieveValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_storageKey)) {
      return const Settings.empty();
    }

    final Map<String, dynamic> json =
        jsonDecode(prefs.getString(_storageKey)) as Map<String, dynamic>;

    final List<TdModel> models = await Future.wait(<Future<TdModel>>[
      _tdModelFromJson(
        json,
        'branchId',
        topdeskProvider.branch,
      ),
      _tdModelFromJson(
        json,
        'categoryId',
        topdeskProvider.category,
      ),
      _tdModelFromJson(
        json,
        'callerId',
        topdeskProvider.caller,
      ),
      _tdModelFromJson(
        json,
        'subCategoryId',
        topdeskProvider.subCategory,
      ),
      _tdModelFromJson(
        json,
        'incidentDurationId',
        topdeskProvider.incidentDuration,
      ),
      _tdModelFromJson(
        json,
        'incidentOperatorId',
        topdeskProvider.incidentOperator,
      ),
    ]);

    final Branch branch = models[0] as Branch;
    final Category category = models[1] as Category;
    final Caller caller = models[2] as Caller;
    final SubCategory subCategory = models[3] as SubCategory;
    final IncidentDuration incidentDuration = models[4] as IncidentDuration;
    final IncidentOperator incidentOperator = models[5] as IncidentOperator;

    return Settings(
      branch: branch,
      caller: _paternityTest(caller, caller.branch, branch) as Caller,
      category: category,
      subCategory: _paternityTest(subCategory, subCategory.category, category)
          as SubCategory,
      incidentDuration: incidentDuration,
      incidentOperator: incidentOperator,
    );
  }

  Future<TdModel> _tdModelFromJson(
    Map<String, dynamic> json,
    String jsonKey,
    Function fetchModel,
  ) async {
    try {
      return json.containsKey(jsonKey)
          ? fetchModel(id: json[jsonKey]) as Future<TdModel>
          : null;
    } on TdModelNotFoundException {
      return null;
    }
  }

  TdModel _paternityTest(
    TdModel child,
    TdModel realParent,
    TdModel chosenParent,
  ) =>
      (realParent == chosenParent) ? child : null;

  @override
  Future<void> save(Settings settings) async {
    assert(_storageKey != null, 'init has not been called');

    _value = settings;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_settingsToJson(settings)),
    );
  }

  Map<String, String> _settingsToJson(Settings settings) {
    return <String, String>{
      'branchId': settings.branch.id,
      'callerId': settings.caller.id,
      'categoryId': settings.category.id,
      'subCategoryId': settings.subCategory.id,
      'incidentDurationId': settings.incidentDuration.id,
      'incidentOperatorId': settings.incidentOperator.id,
    };
  }

  @override
  Future<void> delete() async {
    assert(_storageKey == null, 'init has already been called');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _value = null;
  }

  @override
  void dispose() {
    _storageKey = null;
    _value = null;
  }
}
