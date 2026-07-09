import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;

class TradeAnalysisAPI {

// ✅ CHANGE RETURN TYPE + PARSING
  // ✅ CHANGE RETURN TYPE + PARSING
  static Future<Map<String, dynamic>> analyzeCar(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse(Urls.carAnalyzeUrl),
      headers: {
        "Content-Type": "application/json",
      },
      // Body is a List of objects
      body: jsonEncode([carData]),
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      if (result.isNotEmpty) {
        return result[0] as Map<String, dynamic>;
      }
      throw Exception("Empty analysis result");
    } else {
      throw Exception("Failed to analyze car: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> compareCars(List<Map<String, dynamic>> carsData) async {
    final response = await http.post(
      Uri.parse(Urls.compareUrl),
      headers: {
        "Content-Type": "application/json",
      },
      // Body is an object with "cars" key
      body: jsonEncode({"cars": carsData}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result as Map<String, dynamic>;
    } else {
      throw Exception("Failed to compare cars: ${response.body}");
    }
  }

}
