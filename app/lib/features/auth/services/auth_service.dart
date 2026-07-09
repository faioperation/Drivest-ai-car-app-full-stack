import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:drivest_office/app/urls.dart';

class AuthService {
  /// Returns a Map with status: SUCCESS, TRIAL_EXPIRED, DEACTIVATED, FAILED
  /// temp_token is provided if TRIAL_EXPIRED
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    bool remember = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.signInUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("🔹 Login Response: $data");


      // Deactivated account
      if (data['code'] == "USER_DEACTIVATED") {
        return {"status": "DEACTIVATED"};
      }
      if (data['code'] == "USER_PENDING") {
        return {"status": "Pending"};
      }

      // Trial expired
      if (data['trialExpired'] == true) {
        return {
          "status": "TRIAL_EXPIRED",
          "temp_token": data['accessToken'],
        };
      }

      // Active subscription
      if (response.statusCode == 200 && data['accessToken'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['accessToken']);
        return {"status": "SUCCESS"};
      }


      return {"status": "FAILED"};
    } catch (e) {
      print("Login Error: $e");
      return {"status": "FAILED"};
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse(Urls.deleteAccountUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        prefs.remove("token");
        return true;
      }
      return false;
    } catch (e) {
      print("Delete Account Error: $e");
      return false;
    }
  }
}
