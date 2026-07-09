import 'package:drivest_office/home/pages/profile/profile_page.dart';
import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/network/brand_service.dart';
import '../../widgets/brand_item.dart';
import '../model/brand_model.dart';
import '../widgets/custome_bottom_nav_bar.dart';
import 'ai_chat_page.dart';
import 'compare_selection_page.dart';
import 'filtered_car_page.dart';

class TopBrandsPage extends StatefulWidget {
  const TopBrandsPage({super.key});

  @override
  State<TopBrandsPage> createState() => _TopBrandsPageState();
}

class _TopBrandsPageState extends State<TopBrandsPage> {
  late Future<List<BrandModel>> _brandsFuture;


  @override
  void initState() {
    super.initState();
    _brandsFuture = _loadBrands();
  }

  Future<List<BrandModel>> _loadBrands() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return BrandService.fetchBrands(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrivestAppBar(title: "Top Brands"),
      body: FutureBuilder<List<BrandModel>>(
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

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Column(
                  children: [
                    BrandItem(
                      imageUrl: brand.image,
                      brandId: brand.id,
                      onTap: (id) {
                        print("Tapped brand id: $id");
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
                            builder: (context) => FilteredCarPage(filters: filters),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      brand.name,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
          );
        },
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompareSelectionPage()));
          }
          if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SavedPage()));
          }
          if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AiChatPage()));
          }
          if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }
        },
      ),
    );
  }
}
