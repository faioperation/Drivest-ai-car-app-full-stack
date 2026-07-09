import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarImageSlider extends StatefulWidget {
  const CarImageSlider({super.key});

  @override
  State<CarImageSlider> createState() => _CarImageSliderState();
}

class _CarImageSliderState extends State<CarImageSlider> {
  int _currentIndex = 0;

  final List<String> carImages = [
    'assets/images/tesla_car.png',
    'assets/images/tesla_car.png',
    'assets/images/tesla_car.png',
    'assets/images/tesla_car.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 307,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            enlargeCenterPage: false,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: carImages.map((imagePath) {
            return Container(
              width: double.infinity,
              color: const Color(0xffCCDCE9),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carImages.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color(0xFF015093)
                    : Color(0xFFCCDCE9),
              ),
            );
          }),
        ),
      ],
    );
  }
}
