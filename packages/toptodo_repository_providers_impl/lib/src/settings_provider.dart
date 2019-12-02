import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SharedPreferencesSettingsProvider extends SettingsProvider {
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

    return (prefs.containsKey(_key))
        ? Settings.fromJson(jsonDecode(prefs.getString(_key)))
        : null;
  }

  @override
  Future<void> save(Settings settings) async {
    assert(_key != null, 'init has not been called');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
