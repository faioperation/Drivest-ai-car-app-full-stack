import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BrandItem extends StatelessWidget {
  final String imageUrl;
  final String brandId;
  final void Function(String brandId) onTap;

  const BrandItem({
    required this.imageUrl,
    required this.brandId,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(brandId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: _buildBrandImage(),
        ),
      ),
    );
  }

  Widget _buildBrandImage() {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/tesla_logo.png',
        fit: BoxFit.contain,
      );
    }

    // SVG check
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        placeholderBuilder: (context) =>
            Image.asset('assets/images/tesla_logo.png'),
        height: 50,
        width: 50,
      );
    }

    // Normal image
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      key: ValueKey(imageUrl),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        // 🔹 Retry once after short delay
        Future.delayed(const Duration(milliseconds: 200), () {
          print("Retry loading image: $imageUrl");
        });
        return Image.asset(
          'assets/images/tesla_logo.png',
          fit: BoxFit.contain,
        );
      },
    );

  }
}
