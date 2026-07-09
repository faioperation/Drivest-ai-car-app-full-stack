import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../app/asset_paths.dart';

class LogoWithContainer extends StatelessWidget {
  const LogoWithContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 440,
            width: 440,
            decoration: BoxDecoration(
              color: Color(0xFF015093),
            ),
            child: SvgPicture.asset(AssetPaths.appLogoSvg),
          ),
        ],
      ),
    );
  }
}
