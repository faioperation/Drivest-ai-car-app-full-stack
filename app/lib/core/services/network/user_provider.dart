import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_api.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userData = {
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'phone': prefs.getString('user_phone') ?? '',
      'dob': prefs.getString('user_dob') ?? '',
      'address': prefs.getString('user_address') ?? '',
      'profile_image': prefs.getString('user_image') ?? '',
    };
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    print("UserProvider: Starting fetch...");
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic>? remote = await ApiService.getUserProfileWithToken();

    if (remote != null) {
      _userData = Map<String, dynamic>.from(remote);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userData!['name'] ?? '');
      await prefs.setString('user_email', _userData!['email'] ?? '');
      await prefs.setString('user_phone', _userData!['phone'] ?? '');
      await prefs.setString('user_dob', _userData!['dob'] ?? '');
      await prefs.setString('user_address', _userData!['address'] ?? '');
      await prefs.setString('image', _userData!['image'] ?? '');
      print("Saved to SharedPrefs: ${_userData!['name']}");
    } else {
      print("No user data received!");
    }

    _isLoading = false;
    notifyListeners();
    print("UserProvider: Fetch complete! Data: $_userData");
  }

  Future<bool> updateUserProfile({
    required String name,
    required String phone,
    required String dob,
    required String address,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';

    final Map<String, dynamic> updatedData = {
      'name': name,
      'phone': phone,
      'dob': dob,
      'address': address,
      'email': email,
    };

    if (updatedData['dob'].contains('/') && updatedData['dob'].split('/').length == 3) {
      List<String> parts = updatedData['dob'].split('/');
      try {
        updatedData['dob'] =
        '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      } catch (e) {
        print('❌ DOB Parse Error: $e');
      }
    }

    final bool success =
    await ApiService.updateUserProfile(updatedData, imageFile: imageFile);

    if (success) {
      _userData ??= {};
      _userData!['name'] = name;
      _userData!['phone'] = phone;
      _userData!['dob'] = dob;
      _userData!['address'] = address;
      if (imageFile != null) {
        _userData!['image'] = imageFile.path;
      }

      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_dob', dob);
      await prefs.setString('user_address', address);
      if (imageFile != null) {
        await prefs.setString('image', imageFile.path);
      }
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
