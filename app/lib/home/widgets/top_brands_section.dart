import 'package:drivest_office/home/pages/top_brands_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/network/brand_service.dart';
import '../../widgets/brand_item.dart';
import '../model/brand_model.dart';
import '../pages/filtered_car_page.dart';

class TopBrandsSection extends StatefulWidget {
  const TopBrandsSection({super.key});

  @override
  State<TopBrandsSection> createState() => _TopBrandsSectionState();
}

class _TopBrandsSectionState extends State<TopBrandsSection> {
  Future<List<BrandModel>>? _brandsFuture;
  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  void _loadBrands() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    setState(() {
      _brandsFuture = BrandService.fetchBrands(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Top Brands',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TopBrandsPage()),
                );
              },
              child: const Text(
                "view all",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(1, 80, 147, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ✅ Null check added
        SizedBox(
          height: 80,
          child: _brandsFuture == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<BrandModel>>(
            future: _brandsFuture,

            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No brands found"));
              }

              final brands = snapshot.data!;
              print("Total brands fetched: ${brands.length}");
              for (var brand in brands) {
                print("Brand: ${brand.name}, Image URL: ${brand.image}");
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return BrandItem(
                    imageUrl: brand.image,
                    brandId: brand.id,
                    onTap: (id) {
                      debugPrint("🟢 Brand tapped: $id");
                      final filters = {
                        'brand': brand.name,
                        'fuelType': null,
                        'carType': null,
                        'condition': null,
                        'location': null,
                        'minPrice': 0,
                        'maxPrice': 1000000,
                        'yearMin': 2000,
                        'yearMax': DateTime.now().year,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FilteredCarPage(filters: filters),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

