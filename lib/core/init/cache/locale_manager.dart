import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();
  SharedPreferences? _preferences;
  static LocaleManager get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) => _preferences = value);
  }

  static Future<void> preferencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
    return;
  }

  Future<void> setStringValue(String key, String value) async {
    await _preferences?.setString(key.toString(), value);
  }

  Future<bool?> resetValue(String key) async {
    return await _preferences?.remove(key);
  }

  String? getStringValue(String key) => _preferences?.getString(key);
}
