import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'model/settings.dart';

typedef SettingsProviderFactory = SettingsProvider Function(
  String url,
  String loginName,
);

abstract class SettingsProvider {
  Future<Settings> provide();
  Future<void> save(Settings settings);
}

class SharedPreferencesSettingsProvider extends SettingsProvider {
  factory SharedPreferencesSettingsProvider(String url, String loginName) {
    return SharedPreferencesSettingsProvider._(_generateMd5(url + loginName));
  }

  SharedPreferencesSettingsProvider._(this._key);

  final String _key;

  static String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  Future<Settings> provide() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return (prefs.containsKey(_key))
        ? Settings.fromJson(jsonDecode(prefs.getString(_key)))
        : null;
  }

  @override
  Future<void> save(Settings settings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
