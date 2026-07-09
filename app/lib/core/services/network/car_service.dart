import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/model/car_details_model.dart';
import '../../../home/model/car_model.dart';
import 'auth_utils.dart';

class CarService {
  static Future<List<CarModel>> fetchFeaturedCars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(Urls.carsUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      print("🔹 Cars API Status: ${response.statusCode}");
      print("🔹 Cars API Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["data"] != null) {
          final List carsJson = data["data"];
          return carsJson.map((json) => CarModel.fromJson(json)).toList();
        } else {
          return [];
        }
      }
      if (response.statusCode == 401) {
        // Token expired → force logout
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        // Throw a custom exception
        throw Exception('TOKEN_EXPIRED');
      }

      else {
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }


  static Future<CarDetailsModel> fetchCarDetails(String carId) async {
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
      return CarDetailsModel.fromJson(jsonData['data']);
    } else {
      throw Exception(
        'Failed to fetch car details (${response.statusCode}): ${response
            .body}',
      );
    }
  }
}
