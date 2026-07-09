import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Opacity(
              opacity: 0.08,
              child: SvgPicture.asset('assets/images/building.svg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DO YOU HAVE', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      const Text('suggest from AI for car buy', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Text('Open an AI chat & get AI-powered suggestions instantly to make the right car choice.',
                          style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 100, width: 100,
                  child: SvgPicture.asset('assets/images/styring.svg', fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
