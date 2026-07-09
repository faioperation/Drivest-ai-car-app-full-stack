import 'dart:convert';
import 'package:drivest_office/app/app_strings.dart';
import 'package:drivest_office/app/urls.dart';
import 'package:drivest_office/home/pages/car_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/top_appbar.dart';
import 'widgets/condition_selector.dart';
import 'widgets/search_and_filter.dart';
import 'widgets/featured_car_section.dart';
import 'widgets/top_brands_section.dart';
import 'widgets/recommended_section.dart';
import 'widgets/ai_suggestion_card.dart';
import 'pages/filter_page.dart';

class CombinedHomePage extends StatefulWidget {
  const CombinedHomePage({super.key});

  @override
  State<CombinedHomePage> createState() => _CombinedHomePageState();
}

class _CombinedHomePageState extends State<CombinedHomePage> {
  final List<String> conditionOptions = const ['New', 'Old', 'Repaired'];

  String selectedCondition = 'New';
  String selectedCategory = '';

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  List<dynamic> allCars = [];  // <- added
  List<dynamic> carList = [];  // <- filtered list

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars([Map<String, dynamic>? filters]) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final queryParams = {
        'status': 'published',
        'page': '1',
        'limit': '500',       // fetch more so filtering works better
        'sort': '-publishedAt',
        if (searchController.text.isNotEmpty) 'q': searchController.text,
      };

      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            queryParams[key] = value.toString();
          }
        });
      }

      debugPrint('Query Params: $queryParams');

      final uri =
      Uri.parse(Urls.carsUrl).replace(queryParameters: queryParams);

      final res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        debugPrint('API Response: $data');

        if (data['success'] == true) {
          allCars = data['data'] ?? [];
          _applyFilters();  // <- filter after fetching
        }
      } else {
        debugPrint('Failed: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('API error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// FILTERING FUNCTION
  void _applyFilters() {
    List<dynamic> filtered = [];

    for (var car in allCars) {
      final year = int.tryParse(car['year']?.toString() ?? '') ?? 0;
      final condition = car['condition']?.toString().toLowerCase() ?? '';

      if (selectedCondition == "New") {
        if (year > 2020) filtered.add(car);
      } else if (selectedCondition == "Old") {
        if (year <= 2020) filtered.add(car);
      } else if (selectedCondition == "Repaired") {
        if (condition == "repaired") filtered.add(car);
      }
    }

    setState(() {
      carList = filtered.take(15).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = screenHeight * 0.22;
    const double containerHeight = 160.0;
    const double overlapHeight = containerHeight / 2;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: appBarHeight,
            child: TopAppBar(appBarHeight: appBarHeight),
          ),
          Positioned(
            top: appBarHeight - overlapHeight,
            left: 16,
            right: 16,
            height: containerHeight,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  ConditionSelector(
                    options: conditionOptions,
                    selected: selectedCondition,
                    onChanged: (v) {
                      setState(() => selectedCondition = v);
                      _applyFilters();   // <- changed
                    },
                  ),
                  const SizedBox(height: 16),
                  SearchAndFilter(
                    controller: searchController,
                    onSearch: () => fetchCars(),
                    onFilterTap: () async {
                      final filters = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FilterPage()),
                      );
                      if (filters != null && filters is Map) {
                        fetchCars(Map<String, dynamic>.from(filters));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: appBarHeight + overlapHeight + 20,
            left: 24,
            right: 24,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (carList.isEmpty)
                    const Text("No cars found", style: TextStyle(color: Colors.grey))
                  else
                    _buildCarList(),

                  const SizedBox(height: 24),
                  const FeaturedCarSinglePage(),
                  const SizedBox(height: 24),
                  const TopBrandsSection(),
                  const SizedBox(height: 16),
                  const RecommendedSection(),
                  const SizedBox(height: 24),
                  const AiSuggestionCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarList() {
    return Column(
      children: carList.map((car) {
        final carId = car['_id'] ?? car['id'] ?? '';

        final rawUrl = car['image'];
        final imageUrl = (rawUrl != null && rawUrl.toString().trim().isNotEmpty)
            ? rawUrl.toString()
            : null;

        final title = car['title'] ?? 'Unknown Car';
        final make = car['make'] ?? '';
        final model = car['model'] ?? '';
        final price = car['price']?.toString() ?? 'N/A';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (_) => CarDetailsScreen(carId: carId),

                ),
              );
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        //Image.asset("assets/images/car.png"),
                        Image.asset("assets/images/car_imgae_for_demo.jpg"),

                  )
                      //: Image.asset("assets/images/car.png"),
                      : Image.asset("assets/images/car_imgae_for_demo.jpg"),

                ),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "$make • $model\n\ ${AppStrings.currencySign}$price",
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              isThreeLine: true,
            ),
          ),
        );
      }).toList(),
    );
  }
}
