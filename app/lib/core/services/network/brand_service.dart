import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import '../../../home/model/brand_model.dart';
import 'auth_utils.dart';

class BrandService {

  static Future<List<BrandModel>> fetchBrands(String token) async {
    final url = Uri.parse(Urls.topBrandsUrl);

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401 ||
        response.statusCode == 402 ||
        response.statusCode == 403) {
      await AuthUtils.handleUnauthorized();
      throw Exception("Unauthorized! Logging out...");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> brandsList = data["brands"];
      return brandsList.map((json) => BrandModel.fromJson(json)).toList();
    }
    else {
      throw Exception("Failed to load brands");
    }
  }
}
