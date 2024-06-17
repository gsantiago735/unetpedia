import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static const String _userIdKey = "userId";
  static const String _tokenKey = "tokenKey";
  static const String _accessToken = "accessToken";
  static const String _emailKey = "emailKey";
  static const String _passwordKey = "passwordKey";

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //Writte

  static Future<void> setSession(
      {required String? userId,
      required String? token,
      required String? accessToken}) async {
    if ((userId ?? "").isEmpty) {
      throw Exception("userId is null");
    }
    if ((token ?? "").isEmpty) {
      throw Exception("token is null");
    }
    if ((accessToken ?? "").isEmpty) {
      throw Exception("accessToken is null");
    }

    await prefs.setString(_userIdKey, userId!);
    await prefs.setString(_tokenKey, token!);
    await prefs.setString(_accessToken, accessToken!);
  }

  static Future<void> setCredentials(
      {required String? email, required String? password}) async {
    if ((email ?? "").isEmpty) {
      throw Exception("Email is null");
    }
    if ((password ?? "").isEmpty) {
      throw Exception("Password is null");
    }

    await prefs.setString(_emailKey, email!);
    await prefs.setString(_passwordKey, password!);
  }

  // Get

  static String? getEmail() => prefs.getString(_emailKey);

  static String? getPassword() => prefs.getString(_passwordKey);

  static String? getToken() => prefs.getString(_tokenKey);

  static String? getAccessToken() => prefs.getString(_accessToken);

  static String? getUserId() {
    final id = prefs.getString(_userIdKey);

    try {
      if (id == null) {
        throw Exception("-------EL ID DEL USUARIO ES NULO-------");
      }
    } catch (e) {
      log(e.toString());
    }

    log(id.toString());
    return id;
  }

  // Delete

  static Future<void> deleteSession() async {
    await prefs.remove(_tokenKey);
    await prefs.remove(_accessToken);
  }

  static Future<void> deleteCredentials() async {
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }

  static Future<void> clear() async {
    await prefs.clear();
  }
}
