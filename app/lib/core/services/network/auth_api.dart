import 'dart:convert';
import 'dart:io';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/combined_home_page.dart';
import '../../../home/model/car_model.dart';
import 'auth_utils.dart';

class ApiService {

  // Future<bool> signIn({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(Urls.signInUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "email": email,
  //         "password": password,
  //       }),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("Login Response: $data");
  //
  //     if (response.statusCode == 200) {
  //       final prefs = await SharedPreferences.getInstance();
  //
  //       if (data['accessToken'] != null) {
  //         await prefs.setString('token', data['accessToken']);
  //       }
  //
  //       if (data['trialExpired'] == true) {
  //         throw Exception("TRIAL_EXPIRED");
  //       }
  //
  //       return true;
  //     }
  //
  //     if (response.statusCode == 403) {
  //       final prefs = await SharedPreferences.getInstance();
  //       if (data['accessToken'] != null) {
  //         await prefs.setString('token', data['accessToken']);
  //       }
  //       throw Exception("TRIAL_EXPIRED");
  //     }
  //
  //     throw Exception("LOGIN_FAILED: ${response.statusCode}");
  //   } catch (e) {
  //     print("Login Error: $e");
  //     rethrow;
  //   }
  // }


  static Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.signUpUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );
      print("this is the respone : ${response.body}");

      print("Status Code : ${response.statusCode}");

      if (response.statusCode == 201) {
        print("User successfully saved to backend");
        return true;
      } else {
        print("error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Network Error: $e");
      return false;
    }
  }


  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse(Urls.forgotPassUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send reset code');
    }
  }

  static Future<Map<String, dynamic>> verifyForgotPasswordOtp(
      String email, String otp) async {
    final url = Uri.parse(Urls.verifyOtpUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to verify OTP");
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse(Urls.resetPassUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Failed to reset password. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>?> getUserProfileWithToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print("🔥 Token: $token");

      if (token == null || token.isEmpty) {
        print("❌ No Token Found!");
        return null;
      }

      final response = await http.get(
        Uri.parse(Urls.userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🔥 Profile API Response: ${response.statusCode}");
      print("🔥 Profile API Body: ${response.body}");

      if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403) {
        await AuthUtils.handleUnauthorized();
        throw Exception("Unauthorized! Logging out...");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'] ?? data;
        print("✅ User Data: $user");
        return user;
      } else {
        print("❌ Profile API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Profile Exception: $e");
      return null;
    }
  }

  static Future<bool> updateUserProfile(Map<String, dynamic> data, {File? imageFile}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Urls.editProfileUrl),
      );

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }


      var response = await request.send();

      if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403) {
        await AuthUtils.handleUnauthorized();
        throw Exception("Unauthorized! Logging out...");
      }

      if (response.statusCode == 200) {
        print("✅ Profile updated successfully!");
        return true;
      } else {
        print("❌ Failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error updating profile: $e");
      return false;
    }
  }

  static Future<CarModel> fetchCarDetails(String carId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse(Urls.carDetailsUrl(carId));

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401 ||
        response.statusCode == 402 ||
        response.statusCode == 403) {
      await AuthUtils.handleUnauthorized();
      throw Exception("Unauthorized! Logging out...");
    }


    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return CarModel.fromJson(jsonData['data']);
    } else {
      throw Exception(
          'Failed to fetch car details (${response.statusCode}): ${response.body}');
    }
  }

  static Future<List<dynamic>> getCarList({String query = ''}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final url = query.isEmpty
          ? Urls.carsUrl
          : '${Urls.carsUrl}?search=$query';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403) {
        await AuthUtils.handleUnauthorized();
        throw Exception("Unauthorized! Logging out...");
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] ?? [];
      } else {
        print('❌ getCarList failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ getCarList exception: $e');
      return [];
    }
  }

}
