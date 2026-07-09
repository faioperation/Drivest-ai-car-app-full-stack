import 'dart:async';
import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// optional: use flutter_secure_storage for production, uncomment below and pubspec add it
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // optional secure storage instance:
  // final _secureStorage = const FlutterSecureStorage();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sign-in cancelled")));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? tokenId = googleAuth.idToken;

      if (tokenId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to get ID Token")));
        return;
      }

      // Debug: mask token when logging
      debugPrint("Got Google ID token (masked): ${tokenId.substring(0, 10)}...");

      final uri = Uri.parse(Urls.signInWithGoogleUrl);
      final response = await http
          .post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": tokenId}), // ensure backend expects this key
      )
          .timeout(const Duration(seconds: 15));

      debugPrint('SignInWithGoogle => status: ${response.statusCode}');
      debugPrint('SignInWithGoogle => body: ${response.body}');

      Map<String, dynamic>? data;
      if (response.body.isNotEmpty) {
        try {
          final parsed = jsonDecode(response.body);
          if (parsed is Map<String, dynamic>) data = parsed;
        } catch (e) {
          debugPrint('JSON decode error: $e');
        }
      }

      if (response.statusCode == 200 && data != null) {
        final tokenFromServer = data['token'] as String?;
        final user = data['user'];

        if (tokenFromServer == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Server did not return auth token")),
          );
          return;
        }

        // --- store token ---
        // Production: use flutter_secure_storage. Below uses SharedPreferences for minimal change:
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("idToken", tokenFromServer);
        await prefs.setString("user", jsonEncode(user ?? {}));

        // If using flutter_secure_storage, replace above with:
        // await _secureStorage.write(key: 'jwt', value: tokenFromServer);
        // await _secureStorage.write(key: 'user', value: jsonEncode(user ?? {}));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In Successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainBottomNavScreen()),
        );
      } else {
        // build an error message safely
        String err = "Login failed";
        if (data != null) {
          err = data['message'] ?? data['error'] ?? err;
        } else {
          err = "Login failed: ${response.statusCode}";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    } on http.ClientException catch (e) {
      debugPrint("Network error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Network error: $e")));
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request timed out")));
    } catch (e, st) {
      debugPrint("Google Sign-In Error: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }
}
