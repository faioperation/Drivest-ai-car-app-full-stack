import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/model/car_model.dart';

class FavoriteService {
  static Future<Map<String, dynamic>> favoriteCar(String carId) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(Urls.addFavouriteUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'carId': carId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Added to favourites'};
      } else {
        print('❌ favouriteCar failed: ${response.body}');
        return {'success': false, 'message': 'Failed to add favourite'};
      }
    } catch (e) {
      print('❌ Error in favoriteCar: $e');
      return {'success': false, 'message': 'Error adding favourite'};
    }
  }

  static Future<Map<String, dynamic>> unfavoriteCar(String carId) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse(Urls.deleteFavouriteUrl(carId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Removed from favourites'};
      } else {
        print('❌ unfavoriteCar failed: ${response.body}');
        return {'success': false, 'message': 'Failed to remove favourite'};
      }
    } catch (e) {
      print('❌ Error in unfavoriteCar: $e');
      return {'success': false, 'message': 'Error removing favourite'};
    }
  }

  static Future<List<CarModel>> getSavedCars() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(Urls.showFavouriteUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List<dynamic>?;

        if (items == null) return [];

        return items.map((item) {
          final carJson = item['carId'] as Map<String, dynamic>? ?? {};
          return CarModel.fromJson(carJson);
        }).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error in getSavedCars: $e');
      return [];
    }
  }


  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
