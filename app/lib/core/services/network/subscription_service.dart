import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';

class SubscriptionService {
  // ✅ শুধু subscription URL তৈরির জন্য দরকার
  static Future<String?> createSubscriptionUrl(String token) async {
    final response = await http.post(
      Uri.parse(Urls.createStripeSessionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    }
    return null;
  }
}
