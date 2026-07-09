import 'package:drivest_office/home/pages/car_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/network/car_service.dart';
import '../controller/saved_car_controller.dart';
import '../model/car_model.dart';
import '../../widgets/car_card.dart';
import '../pages/featured_car_list_page.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final savedController = Get.find<SavedCarController>();

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Recommended For You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeaturedCarListPage(titleName: 'Recommended Car'),
                ),
              ),
              child: const Text(
                'view all',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff015093),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 330,
          child: FutureBuilder<List<CarModel>>(
            future: CarService.fetchFeaturedCars(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final cars = snapshot.data ?? [];
              if (cars.isEmpty) {
                return const Center(child: Text('No recommended cars found'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (_) =>  CarDetailsScreen(carId: car.id,)),
                      // );
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 16),
                      child: CarCard(
                        car: car,
                        onFavoriteToggle: () {
                          savedController.toggleSave(car);
                        },
                      ),
                    ),
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
