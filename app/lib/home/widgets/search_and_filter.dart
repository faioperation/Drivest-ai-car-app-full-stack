import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAndFilter extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onFilterTap;

  const SearchAndFilter({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => onSearch(),
                    decoration: const InputDecoration(
                      hintText: 'Search car, brand...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: onSearch,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(1, 80, 147, 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onFilterTap,
            icon: SvgPicture.asset(
              'assets/images/filter-circle-svgrepo-com.svg',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
