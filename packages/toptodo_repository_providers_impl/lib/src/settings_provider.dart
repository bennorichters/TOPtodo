import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SharedPreferencesSettingsProvider extends SettingsProvider {
  SharedPreferencesSettingsProvider(this.topdeskProvider);
  final TopdeskProvider topdeskProvider;

  String _key;

  @override
  void init(String url, String loginName) {
    assert(_key == null, 'init has already been called');
    _key = _generateMd5(url + loginName);
  }

  static String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  Future<Settings> provide() async {
    assert(_key != null, 'init has not been called');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_key)) {
      return null;
    }

    final Map<String, dynamic> json = jsonDecode(prefs.getString(_key));
    return Settings(
      branch: await _tdModelFromJson(
        json,
        'branchId',
        topdeskProvider.branch,
      ),
      caller: await _tdModelFromJson(
        json,
        'callerId',
        topdeskProvider.caller,
      ),
      category: await _tdModelFromJson(
        json,
        'categoryId',
        topdeskProvider.category,
      ),
      subCategory: await _tdModelFromJson(
        json,
        'subCategoryId',
        topdeskProvider.subCategory,
      ),
      incidentDuration: await _tdModelFromJson(
        json,
        'incidentDurationId',
        topdeskProvider.incidentDuration,
      ),
      incidentOperator: await _tdModelFromJson(
        json,
        'incidentOperatorId',
        topdeskProvider.incidentOperator,
      ),
    );
  }

  Future<TdModel> _tdModelFromJson(
    Map<String, dynamic> json,
    String jsonKey,
    Function fetchModel,
  ) async {
    try {
      return json.containsKey(jsonKey) ? fetchModel(id: json[jsonKey]) : null;
    } on TdModelNotFoundException {
      return null;
    }
  }

  @override
  Future<void> save(Settings settings) async {
    assert(_key != null, 'init has not been called');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
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
}
