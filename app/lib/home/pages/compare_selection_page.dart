import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/network/car_provider.dart';
import '../../widgets/small_car_card.dart';
import 'compare_page.dart';
import '../../main_bottom_nav_screen.dart';
import 'package:drivest_office/home/pages/saved_page.dart';

class CompareSelectionPage extends StatefulWidget {
  const CompareSelectionPage({super.key});

  @override
  State<CompareSelectionPage> createState() => _CompareSelectionPageState();
}

class _CompareSelectionPageState extends State<CompareSelectionPage> {
  final Set<int> _selected = {};
  final List<int> _order = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🔹 Fetch featured cars instead of all cars
      Provider.of<CarProvider>(context, listen: false).fetchFeaturedCars();
    });
  }

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
        _order.remove(index);
      } else {
        _selected.add(index);
        _order.add(index);
        if (_order.length > 2) {
          final oldest = _order.removeAt(0);
          _selected.remove(oldest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    const bg = Color(0xffF3F5F7);
    final carProvider = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Select Cars to Compare', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
                  (route) => false,
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: SavedPage.primary),
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: carProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : carProvider.featuredCars.isEmpty
            ? const Center(child: Text('No cars available'))
            : ListView.builder(
          itemCount: carProvider.featuredCars.length,
          itemBuilder: (context, index) {
            final car = carProvider.featuredCars[index];
            final isSelected = _selected.contains(index);

            return GestureDetector(
              onTap: () => _toggle(index),
              child: Stack(
                children: [
                  Opacity(
                    opacity: isSelected ? 0.5 : 1,
                    child: SmallCarCard(
                      car: car,
                      isSelected: isSelected,
                      onTap: () => _toggle(index),
                    ),
                  ),
                  if (isSelected)
                    const Positioned(
                      top: 12,
                      right: 12,
                      child: Icon(Icons.check_circle, color: Colors.green, size: 32),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selected.length == 2
                ? () {
              final selectedCars =
              _order.map((i) => carProvider.featuredCars[i]).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompareResultPage(selectedCars: selectedCars),
                ),
              ).then((_) {
                setState(() {
                  _selected.clear();
                  _order.clear();
                });
              });
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withOpacity(0.35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: const Text(
              'Compare Cars',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
