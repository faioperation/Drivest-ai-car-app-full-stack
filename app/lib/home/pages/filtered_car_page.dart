import 'dart:convert';
import 'package:drivest_office/app/app_strings.dart';
import 'package:drivest_office/app/urls.dart';
import 'package:drivest_office/home/pages/car_details_screen.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FilteredCarPage extends StatefulWidget {
  final Map<String, dynamic> filters;
  const FilteredCarPage({super.key, required this.filters});

  @override
  State<FilteredCarPage> createState() => _FilteredCarPageState();
}

class _FilteredCarPageState extends State<FilteredCarPage> {
  List<dynamic> filteredCars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFilteredCars();
  }

  Future<void> fetchFilteredCars() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final queryParams = {
      'make': widget.filters['brand'] ?? '',
      'fuelType': widget.filters['fuelType'] ?? '',
      'bodyType': widget.filters['carType'] ?? '',
      'condition': widget.filters['condition'] ?? '',
      'location': widget.filters['location'] ?? '',
      'minPrice': (widget.filters['minPrice'] ?? 0).toString(),
      'maxPrice': (widget.filters['maxPrice'] ?? 1000000).toString(),
      'yearMin': (widget.filters['yearMin'] ?? 2000).toString(),
      'yearMax': (widget.filters['yearMax'] ?? DateTime.now().year).toString(),
      'status': 'published',
      'sort': '-publishedAt',
      'page': '1',
      'limit': '20',
    };

    final uri = Uri.parse(Urls.carsUrl).replace(queryParameters: queryParams);
    print("Fetching cars with filters: $queryParams");
    print("API URL: $uri");

    try {
      final response = await http.get(
          uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

      );
      final jsonData = json.decode(response.body);

      print("API Response: $jsonData");

      if (!mounted) return;
      setState(() {
        filteredCars = jsonData['data'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching filtered cars: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrivestAppBar(title: "Filtered Cars"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredCars.isEmpty
          ? const Center(child: Text('No cars found'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCars.length,
        itemBuilder: (context, index) {
          final car = filteredCars[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: car['image'] != null &&
                      car['image'].toString().trim().isNotEmpty
                      ? Image.network(
                    car['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                  )
                      : const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                ),
              ),

              title: Text(
                car['title'] ?? 'Unknown Car',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${car['make'] ?? ''} ${car['model'] ?? ''}\nPrice:  ${AppStrings.currencySign}${car['price'] ?? 'N/A'} | ${car['year'] ?? ''}',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetailsScreen(carId: car['_id'])));
              },
            ),
          );
        },
      ),
    );
  }
}
