import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// A [SettingsProvider] that uses Flutter's [SharedPreferences].
/// 
/// The settings are stored per login name and per url as set in the [init] 
/// method. This [init] method should be called before using the methods 
/// [provide], [save] and [delete].
class SharedPreferencesSettingsProvider extends SettingsProvider {
  String _storageKey;
  Settings _value;

  @override
  void init(String url, String loginName) {
    assert(_storageKey == null, 'init has already been called');
    _storageKey = _generateMd5(loginName + '@' + url);
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

    return (prefs.containsKey(_storageKey))
        ? Settings.fromJson(jsonDecode(prefs.getString(_storageKey)))
        : const Settings();
  }

  @override
  Future<void> save(Settings settings) async {
    assert(_storageKey != null, 'init has not been called');

    _value = settings;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(settings.toJson()),
    );
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
