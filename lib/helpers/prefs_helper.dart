import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  /// ✅ Get string safely (empty string if missing)
  static Future<String> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key);
    if (value == null || value.trim().isEmpty) {
      print("⚠️ [PrefsHelper] No string found for key: $key");
      return "";
    }
    return value;
  }

  /// ✅ Get bool safely (false if missing)
  static Future<bool> getBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  /// ✅ Set string
  static Future<void> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
    print("✅ [PrefsHelper] Saved string [$key] = $value");
  }

  /// ✅ Set bool
  static Future<void> setBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  /// ✅ Set int
  static Future<void> setInt(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  /// ✅ Get int safely (-1 if missing)
  static Future<int> getInt(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? -1;
  }

  /// ✅ Remove specific key
  static Future<void> remove(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
    print("🗑️ [PrefsHelper] Removed key: $key");
  }

  /// ✅ Optional: clear all stored data (use carefully!)
  static Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    print("🧹 [PrefsHelper] All preferences cleared");
  }
}
