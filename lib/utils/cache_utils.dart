import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static Future<void> saveCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(data));
  }

  static Future<dynamic> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  static Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}