import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  final List<String> options;
  final ValueChanged<String> onTap;
  const CategoryButtons({super.key, required this.options, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((option) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () => onTap(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromRGBO(92, 92, 92, 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
              ),
              child: Text(option),
            ),
          ),
        );
      }).toList(),
    );
  }
}
