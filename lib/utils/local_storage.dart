import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static const String _tokenKey = "tokenKey";

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  //Writte

  // static Future<void> setSession({
  //   required String? userType,
  //   required int? id,
  //   required String? token,
  // }) async {
  //   if ((userType ?? "").isEmpty) {
  //     throw Exception("User Type is null");
  //   }
  //   if ((token ?? "").isEmpty) {
  //     throw Exception("token is null");
  //   }
  //   if (id == null) {
  //     throw Exception("User id is null");
  //   }
  //
  //   await prefs.setString(_tokenKey, token!);
  //   await prefs.setInt(_userIdKey, id);
  //   await prefs.setString(_userTypeKey, userType!);
  // }

  // Get

  static String? getToken() {
    final token = prefs.getString(_tokenKey);

    return token;
  }

  // static int? getUserId() {
  //   final id = prefs.getInt(_userIdKey);
  //
  //   try {
  //     if (id == null) {
  //       throw Exception("-------EL ID DEL USUARIO ES NULO-------");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //
  //   log(id.toString());
  //   return id;
  // }

  // Delete

  // static Future<void> deleteSession() async {
  //   await prefs.remove(_tokenKey);
  // }

  static Future<void> clear() async {
    await prefs.clear();
  }
}
