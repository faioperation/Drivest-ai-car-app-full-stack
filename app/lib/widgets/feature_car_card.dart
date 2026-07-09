import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureCarCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String year;
  final String carAsset;
  final String? brandAsset;
  final List<Color> colors;
  final VoidCallback? onViewDetails;
  final VoidCallback? onTapFavorite;
  final bool isFavorite;

  const FeatureCarCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.year,
    required this.carAsset,
    this.brandAsset,
    this.colors = const [],
    this.onViewDetails,
    this.onTapFavorite,
    this.isFavorite = false,
  });

  bool get _carIsSvg => carAsset.toLowerCase().endsWith('.svg');
  bool get _brandIsSvg => (brandAsset ?? '').toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xffE5F1FF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _carIsSvg
                        ? SvgPicture.asset(carAsset, fit: BoxFit.contain, height: 140)
                        : Image.asset(carAsset, fit: BoxFit.contain, height: 140),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF3FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'For Sell',
                    style: TextStyle(
                      color: Color(0xff015093),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: onTapFavorite,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xff1E63B6),
                    ),
                  ),
                ),
              ),

              if (brandAsset != null)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: _brandIsSvg
                        ? SvgPicture.asset(brandAsset!, fit: BoxFit.contain)
                        : Image.asset(brandAsset!, fit: BoxFit.contain),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xff015093),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  location,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Year: ',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              children: [
                                TextSpan(
                                  text: year,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Colour: ',
                                  style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ...colors.map((c) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: onViewDetails,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff1E63B6),
                        backgroundColor: const Color(0xffEAF3FF),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('view details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
