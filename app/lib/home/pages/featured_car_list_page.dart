import 'package:drivest_office/home/pages/profile/profile_page.dart';
import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/network/car_service.dart';
import '../controller/saved_car_controller.dart';
import '../model/car_model.dart';
import '../../widgets/car_card.dart';
import '../widgets/custome_bottom_nav_bar.dart';
import 'ai_chat_page.dart';
import 'car_details_screen.dart';
import 'compare_selection_page.dart';

class FeaturedCarListPage extends StatelessWidget {
  final String titleName;
  const FeaturedCarListPage({super.key, required this.titleName});


  @override
  Widget build(BuildContext context) {
    final savedController = Get.find<SavedCarController>();

    return Scaffold(
      appBar: DrivestAppBar(title: titleName),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<CarModel>>(
          future: CarService.fetchFeaturedCars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final cars = snapshot.data ?? [];

            if (cars.isEmpty) {
              return const Center(
                child: Text('No featured cars available'),
              );
            }

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      CarCard(
                        car: car,
                        onFavoriteToggle: () {
                          savedController.toggleSave(car);
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE5EEF6),
                            foregroundColor: const Color(0xff015093),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CarDetailsScreen(carId: car.id),
                              ),
                            );
                          },
                          child: const Text('view details'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
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
