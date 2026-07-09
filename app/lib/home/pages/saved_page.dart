import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/saved_car_controller.dart';
import '../../widgets/car_card.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';

class SavedPage extends StatefulWidget {
  static const primary = Color(0xff015093);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final SavedCarController savedController = Get.find();

  @override
  void initState() {
    super.initState();
    savedController.loadSavedCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Saved Cars', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
                  (route) => false,
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: SavedPage.primary),
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: Obx(() {
        if (savedController.savedCars.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: savedController.loadSavedCars,
              child: const Text("Load Saved Cars"),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: savedController.loadSavedCars,
          child: ListView.builder(
            itemCount: savedController.savedCars.length,
            itemBuilder: (context, index) {
              final car = savedController.savedCars[index];
              return CarCard(
                car: car,
                onFavoriteToggle: () async {
                  await savedController.toggleSave(car);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
