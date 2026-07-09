import 'package:drivest_office/features/onBoarding/ui/screen/on_boarding_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/asset_paths.dart';
import '../../../../home/pages/car_details_screen.dart';
import '../../../../home/pages/models/car_details_model.dart';

class OnBoardingScreenOne extends StatefulWidget {
  const OnBoardingScreenOne({super.key});

  @override
  State<OnBoardingScreenOne> createState() => _OnBoardingScreenOneState();

  static Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}
final carData = CarDetailsModel(
  title: 'Tesla Model 3',
  description: 'Tesla model 3 is an all-electric compact sedan.',
  imageUrl: 'https://your-image-url.com/car.png',
  seats: 5,
  power: '85 kW (116 hp)',
  engineSize: '1560 cc',
  mileage: 290000,
  maxSpeed: 200,
  engineOutput: 50,
  suggestedPrice: 20000,
  resalePrice: 22000,
  repairCost: 20000,
  estimatedProfit: 22000,
  price: 25000,
);


class _OnBoardingScreenOneState extends State<OnBoardingScreenOne> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF015093),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),

                SizedBox(
                  height: size.height * 0.35,
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPaths.appLogoSvg,
                      height: size.height * 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome to Drivest",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  "Search the dreamy car in Europe",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OnBoardingScreenOne._buildDot(true),
                    OnBoardingScreenOne._buildDot(false),
                    OnBoardingScreenOne._buildDot(false),
                    OnBoardingScreenOne._buildDot(false),
                  ],
                ),

                SizedBox(height: size.height * 0.12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnBoardingScreenTwo(),
                          //builder: (context) => CarDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF015093),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
