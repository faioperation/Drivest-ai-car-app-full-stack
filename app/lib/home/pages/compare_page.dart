// import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../model/car_model.dart';
//
// class CompareResultPage extends StatelessWidget {
//   final List<CarModel> selectedCars;
//
//   const CompareResultPage({super.key, required this.selectedCars});
//
//   @override
//   Widget build(BuildContext context) {
//     const primary = Color(0xff015093);
//     const bg = Color(0xffF3F5F7);
//     const panel = Color(0xffEAF3FF);
//     const labelChip = Color(0xffD7E7F6);
//
//     final carA = selectedCars[0];
//     final carB = selectedCars[1];
//
//     final specs = <_SpecRowData>[
//       _SpecRowData('Title', carA.title, carB.title),
//       _SpecRowData('Company', carA.make, carB.make),
//       _SpecRowData('Price', carA.price.toString(), carB.price.toString()),
//       _SpecRowData('Year', carA.year.toString(), carB.year.toString()),
//       //_SpecRowData('Color', carA.color, carB.color),
//       _SpecRowData('Mileage', carA.mileage.toString(), carB.mileage.toString()),
//       //_SpecRowData('Seats', carA.specs.toString(), carB.specs.toString()),
//     ];
//
//     return Scaffold(
//       backgroundColor: bg,
//       appBar: DrivestAppBar(title: "Compare"),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 84),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(child: _CarHeaderTile(car: carA)),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     'VS',
//                     style: TextStyle(
//                       color: primary,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: _CarHeaderTile(car: carB, alignRight: true)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: panel,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
//               child: Column(
//                 children: specs
//                     .map(
//                       (s) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 6),
//                     child: _SpecRow(
//                       label: s.label,
//                       left: s.left,
//                       right: s.right,
//                       labelBg: labelChip,
//                       panelBg: panel,
//                     ),
//                   ),
//                 )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: SafeArea(
//         top: false,
//         minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//         child: SizedBox(
//           height: 56,
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(28),
//               ),
//             ),
//             child: const Text(
//               'Done',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _CarHeaderTile extends StatelessWidget {
//   final CarModel car;
//   final bool alignRight;
//   const _CarHeaderTile({required this.car, this.alignRight = false});
//
//   bool get _isSvg => car.imageUrl.toLowerCase().endsWith('.svg');
//
//   @override
//   Widget build(BuildContext context) {
//     final carImage = car.imageUrl;
//     Widget imageWidget;
//
//     if (carImage.isEmpty) {
//       imageWidget = Container(
//         height: 80,
//         color: Colors.grey.shade200,
//         child: const Center(child: Icon(Icons.directions_car, size: 40, color: Colors.grey)),
//       );
//     } else {
//       imageWidget = _isSvg
//           ? SvgPicture.asset(carImage, height: 80, fit: BoxFit.contain)
//           : Image.network(carImage, height: 80, fit: BoxFit.contain);
//     }
//
//     return Align(
//       alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
//       child: imageWidget,
//     );
//   }
// }
//
// class _SpecRowData {
//   final String label, left, right;
//   const _SpecRowData(this.label, this.left, this.right);
// }
//
// class _SpecRow extends StatelessWidget {
//   final String label, left, right;
//   final Color labelBg, panelBg;
//   const _SpecRow({
//     required this.label,
//     required this.left,
//     required this.right,
//     required this.labelBg,
//     required this.panelBg,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     const double rowHeight = 64;
//     const double labelWidth = 122;
//     const labelStyle = TextStyle(
//       fontSize: 13,
//       fontWeight: FontWeight.w700,
//       color: Color(0xFF1F1F1F),
//     );
//     const valueStyle = TextStyle(
//       fontSize: 12.5,
//       color: Colors.black87,
//       height: 1.25,
//     );
//
//     return Container(
//       height: rowHeight,
//       decoration: BoxDecoration(
//         color: panelBg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: labelWidth,
//             height: double.infinity,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: labelBg,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Text(label, style: labelStyle, textAlign: TextAlign.center),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 left,
//                 style: valueStyle,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 right,
//                 style: valueStyle,
//                 textAlign: TextAlign.right,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../model/car_model.dart';
import '../pages/services/network/trade_analysis_api.dart';
import '../../app/app_strings.dart';

class CompareResultPage extends StatefulWidget {
  final List<CarModel> selectedCars;

  const CompareResultPage({super.key, required this.selectedCars});

  @override
  State<CompareResultPage> createState() => _CompareResultPageState();
}

class _CompareResultPageState extends State<CompareResultPage> {
  bool isLoading = true;
  Map<String, dynamic>? comparisonData;
  String? errorMessage;

  final Color primaryColor = const Color(0xff015093);
  final Color secondaryColor = const Color(0xffF3F5F7);

  @override
  void initState() {
    super.initState();
    _fetchComparison();
  }

  Future<void> _fetchComparison() async {
    try {
      // 🔹 Construct Safe API Body
      final carsData = widget.selectedCars.map((car) {
        return {
          "title": car.title,
          "brand": car.make,
          "year_numeric": car.year,
          "mileage_numeric": car.mileage,
          "price_numeric": car.price,
          "fuel_type": null, // avoid validation error
          "transmission": null, // avoid validation error
          "url": car.imageUrl.isNotEmpty
              ? car.imageUrl
              : "https://example.com/placeholder.jpg",
          "is_premium": false,
          "age": DateTime.now().year - car.year
        };
      }).toList();

      final result = await TradeAnalysisAPI.compareCars(carsData);

      setState(() {
        comparisonData = result;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const DrivestAppBar(title: "Compare Cars"),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "An error occurred: $errorMessage",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            /// 🏆 Header Section
            _buildVsHeader(),

            const SizedBox(height: 16),

            /// 📊 Comparison Table
            if (comparisonData != null &&
                comparisonData!.containsKey('all_cars'))
              _buildComparisonTable(comparisonData!['all_cars']),

            const SizedBox(height: 24),

            /// 🎯 Recommendation Section
            if (comparisonData != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      "AI Analysis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (comparisonData!['best_overall_deal'] != null)
                _buildBestCard(
                  "Best Overall Deal",
                  comparisonData!['best_overall_deal'],
                  primaryColor,
                  Icons.verified,
                ),
              if (comparisonData!['best_by_profit'] != null)
                _buildBestCard(
                  "Max Profit",
                  comparisonData!['best_by_profit'],
                  Colors.green,
                  Icons.trending_up,
                ),
              if (comparisonData!['best_by_risk'] != null)
                _buildBestCard(
                  "Lowest Risk",
                  comparisonData!['best_by_risk'],
                  Colors.orange[800]!,
                  Icons.shield_outlined,
                ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVsHeader() {
    if (widget.selectedCars.length < 2) return const SizedBox();
    final c1 = widget.selectedCars[0];
    final c2 = widget.selectedCars[1];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildCarHeaderItem(c1)),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              "VS",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(child: _buildCarHeaderItem(c2)),
        ],
      ),
    );
  }

  Widget _buildCarHeaderItem(CarModel car) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            image: car.imageUrl.isNotEmpty
                ? DecorationImage(
                image: NetworkImage(car.imageUrl), fit: BoxFit.cover)
                : const DecorationImage(
                image: AssetImage('assets/images/car_imgae_for_demo.jpg'),
                fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          car.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${AppStrings.currencySign}${car.price}",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonTable(List<dynamic> allCars) {
    if (allCars.length < 2) return const SizedBox();
    final c1 = allCars[0];
    final c2 = allCars[1];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          _tableHeader(),
          _tableRow("Price", "${c1['price_numeric']}", "${c2['price_numeric']}",
              isCurrency: true),
          _tableRow("Year", "${c1['year_numeric']}", "${c2['year_numeric']}"),
          _tableRow(
              "Mileage", "${c1['mileage_numeric']}", "${c2['mileage_numeric']}",
              suffix: " km"),
          _tableRow("Est. Value", "${c1['estimated_market_value']}",
              "${c2['estimated_market_value']}",
              isCurrency: true),
          _tableRow("Profit", "${c1['profit']}", "${c2['profit']}",
              isCurrency: true, highlight: true),
          _tableRow("Risk Score", "${c1['risk_score']}", "${c2['risk_score']}",
              highlight: true, inverseHighlight: true),
          _tableRow("Verdict", "${c1['recommendation']}",
              "${c2['recommendation']}",
              isLast: true, isBadge: true),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: const Row(
        children: [
          Expanded(child: SizedBox()),
          SizedBox(
            width: 100,
            child: Text(
              "Feature",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _tableRow(String label, String v1, String v2,
      {bool isLast = false,
        bool isCurrency = false,
        String suffix = "",
        bool highlight = false,
        bool inverseHighlight = false,
        bool isBadge = false}) {
    Color getValueColor(String val1, String val2) {
      if (!highlight) return Colors.black87;
      final num1 = num.tryParse(val1) ?? 0;
      final num2 = num.tryParse(val2) ?? 0;
      if (num1 == num2) return Colors.black87;
      if (inverseHighlight) {
        return num1 < num2 ? Colors.green : Colors.red;
      }
      return num1 > num2 ? Colors.green : Colors.red;
    }

    Widget buildValue(String val, Color color) {
      if (isBadge) {
        final isBuy = val.toUpperCase().contains("BUY") &&
            !val.toUpperCase().contains("DON'T");
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isBuy ? Colors.green : Colors.red),
          ),
          child: Text(
            val,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isBuy ? Colors.green : Colors.red,
            ),
          ),
        );
      }
      return Text(
        "${isCurrency ? AppStrings.currencySign : ''}$val$suffix",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 13, color: color),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: buildValue(v1, getValueColor(v1, v2)),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: buildValue(v2, getValueColor(v2, v1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestCard(
      String title, Map<String, dynamic> car, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: color.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car['title'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "${car['year_numeric']}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetric(
                          "Profit",
                          "${AppStrings.currencySign}${car['profit']}",
                          Colors.green),
                      _buildMetric(
                          "Risk", "${car['risk_score']}", Colors.orange),
                      _buildMetric(
                          "Value",
                          "${AppStrings.currencySign}${car['estimated_market_value']}",
                          primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
