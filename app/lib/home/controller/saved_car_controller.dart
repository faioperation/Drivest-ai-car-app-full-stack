import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/network/favourite_service.dart';
import '../model/car_model.dart';

class SavedCarController extends GetxController {
  var savedCars = <CarModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedCars();
  }

  Future<void> loadSavedCars() async {
    try {
      final cars = await FavoriteService.getSavedCars();
      savedCars.assignAll(cars);
    } catch (e) {
      print("❌ Failed to load saved cars: $e");
      Get.snackbar(
        "Error",
        "Failed to load saved cars",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
      );
    }
  }

  Future<void> toggleSave(CarModel car) async {
    final alreadySaved = savedCars.any((c) => c.id == car.id);

    if (alreadySaved) {
      savedCars.removeWhere((c) => c.id == car.id);
    } else {
      savedCars.add(car);
    }

    try {
      final result = alreadySaved
          ? await FavoriteService.unfavoriteCar(car.id)
          : await FavoriteService.favoriteCar(car.id);

      final success = result['success'] == true;
      final message = result['message'] ?? (success ? 'Done' : 'Failed');

      if (!success) {
        if (alreadySaved) {
          savedCars.add(car);
        } else {
          savedCars.removeWhere((c) => c.id == car.id);
        }

        Get.snackbar(
          "Error",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800,
        );
      } else {
        Get.snackbar(
          alreadySaved ? "Removed from favourites" : "Added to favourites",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: alreadySaved ? Colors.red.shade50 : Colors.green.shade50,
          colorText: alreadySaved ? Colors.red.shade800 : Colors.green.shade800,
        );
      }
    } catch (e) {
      print("❌ Favourite toggle error: $e");
      if (alreadySaved) {
        savedCars.add(car);
      } else {
        savedCars.removeWhere((c) => c.id == car.id);
      }
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
      );
    }
  }

  bool isSaved(CarModel car) => savedCars.any((c) => c.id == car.id);
}
