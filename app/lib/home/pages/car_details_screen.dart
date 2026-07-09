// // // import 'package:flutter/material.dart';
// // // import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
// // // import '../../app/app_strings.dart';
// // // import '../../core/services/network/auth_api.dart';
// // // import '../model/car_model.dart';
// // // import '../widgets/trade_analysis_widget.dart';
// // // import 'ai_chat_page.dart';
// // //
// // // // Import the separated trade analysis widget
// // // class CarDetailsScreen extends StatefulWidget {
// // //   const CarDetailsScreen({super.key, required this.carId});
// // //   final String carId;
// // //
// // //   @override
// // //   State<CarDetailsScreen> createState() => _CarDetailsScreenState();
// // // }
// // //
// // // class _CarDetailsScreenState extends State<CarDetailsScreen> {
// // //   late Future<CarModel> futureCar;
// // //   bool showAnalysis = false;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     futureCar = ApiService.fetchCarDetails(widget.carId);
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       appBar: const DrivestAppBar(title: "Car Details"),
// // //       body: FutureBuilder<CarModel>(
// // //         future: futureCar,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           if (snapshot.hasError) {
// // //             return Center(child: Text("Error: ${snapshot.error}"));
// // //           }
// // //           if (!snapshot.hasData) {
// // //             return const Center(child: Text("No car details found"));
// // //           }
// // //
// // //           final car = snapshot.data!;
// // //
// // //           return SafeArea(
// // //             child: SingleChildScrollView(
// // //               padding: const EdgeInsets.only(bottom: 20),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //
// // //                   /// Car Image
// // //                   if (car.imageUrl.isNotEmpty)
// // //                     Image.network(
// // //                       car.imageUrl,
// // //                       width: double.infinity,
// // //                       height: 220,
// // //                       fit: BoxFit.cover,
// // //                       errorBuilder: (c, e, s) =>
// // //                       const Icon(Icons.image, size: 100),
// // //                     )
// // //                   else
// // //                     const Icon(Icons.image_not_supported,
// // //                         size: 100, color: Colors.grey),
// // //
// // //                   const SizedBox(height: 16),
// // //
// // //                   /// Car Info Section
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         Text(
// // //                           car.title,
// // //                           style: const TextStyle(
// // //                             fontSize: 18,
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //
// // //                         const SizedBox(height: 6),
// // //
// // //                         Text(
// // //                           car.description,
// // //                           style: const TextStyle(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                         ),
// // //
// // //                         const SizedBox(height: 6),
// // //
// // //                         Text(
// // //                           "${car.make} • ${car.color} • ${car.year}",
// // //                           style: const TextStyle(
// // //                             fontSize: 14,
// // //                             color: Color(0xff5C5C5C),
// // //                             height: 1.4,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //
// // //                   const SizedBox(height: 20),
// // //
// // //                   /// Features Title
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: const Text(
// // //                       "Features",
// // //                       style: TextStyle(
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.w600,
// // //                       ),
// // //                     ),
// // //                   ),
// // //
// // //                   const SizedBox(height: 16),
// // //
// // //                   /// Feature Items
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                       children: [
// // //                         _featureItem(Icons.people, "Seats", "${car.specs}"),
// // //                         _featureItem(Icons.speed, "Mileage", "${car.year} km"),
// // //                         _featureItem(Icons.settings, "Engine", "${car.make}"),
// // //                       ],
// // //                     ),
// // //                   ),
// // //
// // //                   const SizedBox(height: 20),
// // //
// // //                   /// AI Trade Analysis Button
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: SizedBox(
// // //                       width: double.infinity,
// // //                       child: ElevatedButton(
// // //                         onPressed: () {
// // //                           setState(() => showAnalysis = !showAnalysis);
// // //                         },
// // //                         style: ElevatedButton.styleFrom(
// // //                           backgroundColor: const Color(0xff015093),
// // //                           shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           padding: const EdgeInsets.symmetric(vertical: 14),
// // //                         ),
// // //                         child: const Text(
// // //                           "AI Trade Analysis",
// // //                           style: TextStyle(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.w500,
// // //                             color: Colors.white,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //
// // //                   const SizedBox(height: 16),
// // //
// // //                   /// AI Trade Analysis Widget (separated)
// // //                   if (showAnalysis)
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                       child: TradeAnalysisWidget(
// // //                         carData: {
// // //                           "title": car.title,
// // //                           "brand": car.make,
// // //                           "year_numeric": car.year,
// // //                           "mileage_numeric": car.mileage, // তুমি চাইলে correct mileage বসাবে
// // //                           "price_numeric": car.price,
// // //                           "is_premium": 0,
// // //                           "age": DateTime.now().year - car.year,
// // //                           "url": car.imageUrl,
// // //                         },
// // //                       ),
// // //                     ),
// // //
// // //
// // //
// // //                   const SizedBox(height: 24),
// // //
// // //                   /// Price Section + AI Suggestion Button
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text(
// // //                           "Price",
// // //                           style: TextStyle(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //
// // //                         const SizedBox(height: 6),
// // //
// // //                         Row(
// // //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                           children: [
// // //                             Text(
// // //                               "${AppStrings.currencySign}${car.price}",
// // //                               style: const TextStyle(
// // //                                 fontSize: 18,
// // //                                 fontWeight: FontWeight.w600,
// // //                                 color: Color(0xff015093),
// // //                               ),
// // //                             ),
// // //
// // //                             ElevatedButton(
// // //                               onPressed: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                       builder: (_) => const AiChatPage()),
// // //                                 );
// // //                               },
// // //                               style: ElevatedButton.styleFrom(
// // //                                 backgroundColor: const Color(0xff015093),
// // //                                 shape: RoundedRectangleBorder(
// // //                                   borderRadius: BorderRadius.circular(87),
// // //                                 ),
// // //                                 padding: const EdgeInsets.symmetric(
// // //                                   horizontal: 24,
// // //                                   vertical: 12,
// // //                                 ),
// // //                               ),
// // //                               child: const Text(
// // //                                 "AI Suggestion",
// // //                                 style: TextStyle(
// // //                                   fontSize: 16,
// // //                                   color: Colors.white,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   /// Feature Item UI
// // //   Widget _featureItem(IconData icon, String title, String value) {
// // //     return Column(
// // //       children: [
// // //         CircleAvatar(
// // //           radius: 24,
// // //           backgroundColor: const Color(0xffCCDCE9),
// // //           child: Icon(icon, color: const Color(0xff015093)),
// // //         ),
// // //         const SizedBox(height: 8),
// // //         Text(title,
// // //             style: const TextStyle(fontSize: 12, color: Color(0xff5C5C5C))),
// // //         const SizedBox(height: 6),
// // //         Text(value,
// // //             style: const TextStyle(
// // //                 fontSize: 12, fontWeight: FontWeight.w500)),
// // //       ],
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import '../../app/app_strings.dart';
// //
// // class CarDetailsScreen extends StatefulWidget {
// //   const CarDetailsScreen({super.key});
// //
// //   @override
// //   State<CarDetailsScreen> createState() => _CarDetailsScreenState();
// // }
// //
// // class _CarDetailsScreenState extends State<CarDetailsScreen> {
// //   bool showAIAnalysis = false;
// //
// //   final List<String> images = [
// //     'assets/images/car.png',
// //     'assets/images/tesla_car.png',
// //     'assets/images/cvc.png',
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Car Details'),
// //         centerTitle: true,
// //       ),
// //
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //
// //             /// 1️⃣ IMAGE SLIDER
// //             SizedBox(
// //               height: 240,
// //               child: PageView.builder(
// //                 itemCount: images.length,
// //                 itemBuilder: (context, index) {
// //                   return Container(
// //                     margin: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xffd9e8f3),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Image.asset(
// //                       images[index],
// //                       fit: BoxFit.contain,
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //
// //             /// 2️⃣ CAR NAME + DESCRIPTION
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: const [
// //                   Text(
// //                     'Peugeot 308 SW Allure',
// //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
// //                   ),
// //                   SizedBox(height: 6),
// //                   Text(
// //                     'Used car in good condition with full service history.',
// //                     style: TextStyle(color: Colors.grey),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(height: 20),
// //
// //             /// 3️⃣ FEATURES (6 ICONS)
// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: GridView.count(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 crossAxisCount: 3,
// //                 mainAxisSpacing: 16,
// //                 crossAxisSpacing: 16,
// //                 childAspectRatio: .9,
// //                 children: const [
// //                   FeatureItem(icon: Icons.event_seat, label: 'Seats', value: '5'),
// //                   FeatureItem(icon: Icons.bolt, label: 'Power', value: '85 kW'),
// //                   FeatureItem(icon: Icons.settings, label: 'Engine', value: '1560 cc'),
// //                   FeatureItem(icon: Icons.water_drop, label: 'Mileage', value: '290,000'),
// //                   FeatureItem(icon: Icons.speed, label: 'Top Speed', value: '200 km/h'),
// //                   FeatureItem(icon: Icons.favorite, label: 'Output', value: '50 HP'),
// //                 ],
// //               ),
// //             ),
// //
// //             /// 4️⃣ AI TRADE ANALYSIS BUTTON
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 height: 48,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     setState(() {
// //                       showAIAnalysis = !showAIAnalysis;
// //                     });
// //                   },
// //                   child: const Text('AI Trade Analysis'),
// //                 ),
// //               ),
// //             ),
// //
// //             /// 5️⃣ AI OPTIONS + ESTIMATED PRICE
// //             if (showAIAnalysis) ...[
// //               const SizedBox(height: 16),
// //
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: const [
// //                     AIOption(
// //                       icon: Icons.price_check,
// //                       title: 'Suggested',
// //                       value: '\$20,000',
// //                     ),
// //                     AIOption(
// //                       icon: Icons.trending_up,
// //                       title: 'Resale',
// //                       value: '\$22,000',
// //                     ),
// //                     AIOption(
// //                       icon: Icons.build,
// //                       title: 'Repair',
// //                       value: '\$20,000',
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 16),
// //
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(16),
// //                     border: Border.all(color: Colors.blue.shade100),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: const [
// //                       Text('Estimated Profit'),
// //                       Text(
// //                         '\$22,000',
// //                         style: TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //
// //             const SizedBox(height: 8),
// //
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Text("Details",style: TextStyle(fontSize: 20,color: Colors.black),),
// //             ),
// //
// //             /// 6️⃣ DETAILS TABLES
// //             InfoTable(
// //               title: 'Basic Data',
// //               data: {
// //                 'Body type': 'Sedan',
// //                 'Vehicle type': 'Used',
// //                 'Seats': '5',
// //                 'Doors': '5',
// //                 'Country Version': 'N/A',
// //                 'Offer Number': 'N/A',
// //                 'Model Code': 'N/A',
// //               },
// //             ),
// //
// //             InfoTable(
// //               title: 'Vehicle History',
// //               data: {
// //                 'Mileage': '290,000 km',
// //                 'First registration': '12/2011',
// //                 'Previous owners': '1',
// //                 'Service history': 'Yes',
// //                 'Full Service History': 'Yes',
// //                 'General Inspection': 'N/A',
// //               },
// //             ),
// //
// //             InfoTable(
// //               title: 'Technical Data',
// //               data: {
// //                 'Power': '85 kW (116 hp)',
// //                 'Gearbox': 'Manual',
// //                 'Engine size': '1560 cc',
// //                 'Cylinders': '4',
// //                 'Gears': '6',
// //                 'Empty Weight': '1344 kg',
// //               },
// //             ),
// //
// //             InfoTable(
// //               title: 'Energy Consumption',
// //               data: {
// //                 'Emission class': 'Euro 5',
// //                 'Fuel type': 'Diesel',
// //                 'Fuel Consumption': '4.2 l/100 km',
// //                 'CO₂ Emissions': 'N/A',
// //
// //               },
// //             ),
// //
// //             InfoTable(
// //               title: 'Colour and Upholstery',
// //               data: {
// //                 'Colour': 'Grey',
// //                 'Paint': 'Metallic',
// //                 'Manufacturer Colour': 'Black',
// //                 'Upholstery Colour': 'N/A',
// //                 'Upholstery': 'Cloth',
// //               },
// //             ),
// //
// //             InfoTable(
// //               title: 'Seller Info',
// //               data: {
// //                 'Company Name': 'IM Auto SRL',
// //                 'Contact Name': 'Innocenzo Pantaleo',
// //                 'Location': 'Via La Martella - Via delle Arti, 6,\n75100 Matera - Mt, IT',
// //                 'Phone': '+39 0835 386236',
// //               },
// //             ),
// //
// //             const SizedBox(height: 80),
// //           ],
// //         ),
// //       ),
// //
// //       /// 7️⃣ BOTTOM BAR
// //       bottomNavigationBar: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(color: Colors.black12, blurRadius: 6),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             const Text(
// //               'Price ${AppStrings.currencySign} 25,000',
// //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //             ),
// //             const Spacer(),
// //             ElevatedButton(
// //               onPressed: () {},
// //               child: const Text('AI Suggestion'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class FeatureItem extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   final String value;
// //
// //   const FeatureItem({
// //     super.key,
// //     required this.icon,
// //     required this.label,
// //     required this.value,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         CircleAvatar(
// //           radius: 26,
// //           backgroundColor: Colors.blue.shade50,
// //           child: Icon(icon, color: Colors.blue),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
// //         Text(label,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //       ],
// //     );
// //   }
// // }
// //
// // class AIOption extends StatelessWidget {
// //   final IconData icon;
// //   final String title;
// //   final String value;
// //
// //   const AIOption({
// //     super.key,
// //     required this.icon,
// //     required this.title,
// //     required this.value,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         CircleAvatar(
// //           radius: 24,
// //           backgroundColor: Colors.blue.shade50,
// //           child: Icon(icon, color: Colors.blue),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
// //         Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //       ],
// //     );
// //   }
// // }
// //
// // class InfoTable extends StatelessWidget {
// //   final String title;
// //   final Map<String, String> data;
// //
// //   const InfoTable({
// //     super.key,
// //     required this.title,
// //     required this.data,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade300),
// //         color: Colors.grey.shade100,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade200,
// //               borderRadius: const BorderRadius.vertical(
// //                 top: Radius.circular(12),
// //               ),
// //             ),
// //             child: Text(
// //               title,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 16,
// //               ),
// //             ),
// //           ),
// //           ...data.entries.map(
// //                 (e) => Container(
// //               padding:
// //               const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //               decoration: BoxDecoration(
// //                 border: Border(
// //                   top: BorderSide(color: Colors.grey.shade300),
// //                 ),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       e.key,
// //                       style: const TextStyle(color: Colors.grey),
// //                     ),
// //                   ),
// //                   Expanded(
// //                     child: Text(
// //                       e.value,
// //                       textAlign: TextAlign.right,
// //                       style:
// //                       const TextStyle(fontWeight: FontWeight.w500),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//

import 'package:flutter/material.dart';
import '../../app/app_strings.dart';
import '../../core/services/network/car_service.dart';
import '../model/car_details_model.dart';
import '../widgets/profile_page_app_bar.dart';
import '../widgets/trade_analysis_widget.dart';
import 'ai_chat_page.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;
  const CarDetailsScreen({super.key, required this.carId});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool showAIAnalysis = false;
  late Future<CarDetailsModel> futureCar;

  @override
  void initState() {
    super.initState();
    futureCar = CarService.fetchCarDetails(widget.carId);
  }

  String v(dynamic value) {
    if (value == null || value.toString().isEmpty) return 'N/A';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Car Details'),
      //   centerTitle: true,
      // ),
      appBar: const DrivestAppBar(title: "Car Details"),
      body: FutureBuilder<CarDetailsModel>(
        future: futureCar,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final car = snapshot.data!;
          final specs = car.specs;
          final seller = car.sellerInfo;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 1️⃣ IMAGE SLIDER (API)
                SizedBox(
                  height: 240,
                  child: PageView.builder(
                    itemCount:
                    car.images.isNotEmpty ? car.images.length : 1,
                    itemBuilder: (context, index) {
                      final img = car.images.isNotEmpty
                          ? car.images[index]
                          : car.image;
                      return Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9e8f3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(img, fit: BoxFit.contain),
                      );
                    },
                  ),
                ),

                /// 2️⃣ NAME + DESCRIPTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v(car.subtitle),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 3️⃣ FEATURES (SAME ICONS)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: .9,
                    children: [
                      FeatureItem(
                          icon: Icons.event_seat,
                          label: 'Seats',
                          value: v(specs.seats)),
                      FeatureItem(
                          icon: Icons.bolt,
                          label: 'Power',
                          value: '${v(specs.power)} HP'),
                      FeatureItem(
                          icon: Icons.door_front_door,
                          label: 'Doors',
                          value: v(specs.doors)),
                      FeatureItem(
                          icon: Icons.water_drop,
                          label: 'Mileage',
                          value: '${v(car.mileage)} km'),
                      FeatureItem(
                          icon: Icons.speed,
                          label: 'Gearbox',
                          value: v(specs.gearbox)),
                      FeatureItem(
                          icon: Icons.local_gas_station,
                          label: 'Fuel',
                          value: v(car.fuelType)),
                    ],
                  ),
                ),

                /// 4️⃣ AI BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => showAIAnalysis = !showAIAnalysis);
                      },
                      child: const Text('AI Trade Analysis'),
                    ),
                  ),
                ),

                /// 5️⃣ AI TRADE ANALYSIS WIDGET
                if (showAIAnalysis)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: TradeAnalysisWidget(
                      carData: {
                        "title": car.title,
                        "brand": car.make, // Assuming 'make' is the brand
                        "year_numeric": int.tryParse(car.year.toString()) ?? 2020,
                        "mileage_numeric": int.tryParse(car.mileage.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                        "price_numeric": int.tryParse(car.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                        "fuel_type": v(specs.fuelConsumption), // Mapping fuel
                        "transmission": v(specs.gearbox), // Mapping transmission
                        "url": car.image, // Main image
                      },
                    ),
                  ),

                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Details",
                      style: TextStyle(fontSize: 20)),
                ),

                /// 6️⃣ DETAILS TABLES (SAME ORDER)
                InfoTable(
                  title: 'Basic Data',
                  data: {
                    'Make': v(car.make),
                    'Brand': v(car.brand),
                    'Model': v(car.model),
                    'Seats': v(specs.seats),
                    'Doors': v(specs.doors),
                    'Year': v(car.year),
                  },
                ),

                InfoTable(
                  title: 'Vehicle History',
                  data: {
                    'Mileage': '${v(car.mileage)} km',
                    'First registration': v(specs.firstRegistration),
                  },
                ),

                InfoTable(
                  title: 'Technical Data',
                  data: {
                    'Power': v(specs.power),
                    'Gearbox': v(specs.gearbox),
                    'Engine size': v(specs.engineSize),
                    'Cylinders': v(specs.cylinders),
                  },
                ),

                InfoTable(
                  title: 'Energy Consumption',
                  data: {
                    'Fuel type': v(car.fuelType),
                    'Emissions': v(specs.emissions),
                  },
                ),

                InfoTable(
                  title: 'Seller Info',
                  data: {
                    'Company Name': v(seller.companyName),
                    'Contact Name': v(seller.contactName),
                    'Location': v(seller.location),
                  },
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),

      /// 7️⃣ BOTTOM BAR (SAME)
      bottomNavigationBar: FutureBuilder<CarDetailsModel>(
        future: futureCar,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final car = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Text(
                  'Price ${AppStrings.currencySign} ${car.price}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => const AiChatPage()),
                //     );
                //   },
                //   child: const Text('AI Suggestion'),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class AIOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const AIOption({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class InfoTable extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const InfoTable({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          ...data.entries.map(
                (e) => Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.key,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      textAlign: TextAlign.right,
                      style:
                      const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
