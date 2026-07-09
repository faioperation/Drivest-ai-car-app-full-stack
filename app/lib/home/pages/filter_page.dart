import 'package:drivest_office/home/pages/filtered_car_page.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> brands = [
    "7", "A", "Audi", "Auto", "Automaat", "Bmw", "Citroen", "Dacia", "Fiat", "Ford",
    "Honda", "Hyundai", "Iveco", "Kia", "Leasing", "Lexus", "Maserati", "Mercedes",
    "Mercedez-benz", "Mini", "Nissan", "Opel", "Paardenvrachtwagenmobilehome", "Particulieren",
    "Peugeot", "Polo", "Porsche", "Renault", "Riemst", "Scania", "Seat", "Toyota",
    "Tweedehands", "Volkswagen", "Volvo", "Vw",
  ];

  final List<String> fuelTypes = [
    'Petrol (Gasoline)', 'Diesel', 'Premium Petrol',
    'Electric (EV)', 'LPG', 'Hybrid'
  ];

  final List<String> carTypes = [
    'Hatchback', 'Sports Car', 'Sedan', 'Luxury', 'SUV',
    'Crossover', 'Electric / Hybrid', 'Coupe', 'Pickup Truck'
  ];

  final List<String> conditions = ['Excellent', 'Good', 'Needs Repair'];
  final List<String> locations = ['Belgium', 'Netherlands', 'Germany'];

  String? selectedBrand = 'Toyota';
  String? selectedFuelType = 'Diesel';
  String? selectedCarType;
  String? selectedCondition;
  String? selectedLocation;

  bool isButtonClicked = false;
  RangeValues priceRange = RangeValues(5, 7000000);
  RangeValues yearRange = RangeValues(2000, 2010);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.refresh, color: Colors.blue),
              onPressed: () {},
            ),
            title: Text('Filter', style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.blue),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              _buildSectionTitle("Car Brand"),
              _buildSingleSelectChips(brands, selectedBrand, (val) {
                setState(() => selectedBrand = val);
              }, isMandatory: true),

              _buildSectionTitle("Price Range"),
              _buildSlider(
                priceRange,
                RangeValues(0, 10000000),
                "K",
                    (newRange) => setState(() => priceRange = newRange),
              ),

              _buildSectionTitle("Year of Manufacture"),
              _buildSlider(
                yearRange,
                RangeValues(2000, 2025),
                "",
                    (newRange) => setState(() => yearRange = newRange),
              ),

              _buildSectionTitle("Fuel Type"),
              _buildSingleSelectChips(fuelTypes, selectedFuelType, (val) {
                setState(() => selectedFuelType = val);
              }),

              _buildSectionTitle("Car Type"),
              _buildSingleSelectChips(carTypes, selectedCarType, (val) {
                setState(() => selectedCarType = val);
              }),

              _buildSectionTitle("Condition"),
              _buildSingleSelectChips(conditions, selectedCondition, (val) {
                setState(() => selectedCondition = val);
              }),

              _buildSectionTitle("Location"),
              _buildSingleSelectChips(locations, selectedLocation, (val) {
                setState(() => selectedLocation = val);
              }),

            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBottomButton(),
            ))
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSingleSelectChips(
      List<String> options,
      String? selectedValue,
      void Function(String?) onSelected, {
        bool isMandatory = false,
      }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final bool isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              if (isMandatory) {
                onSelected(option);
              } else {
                if (isSelected) {
                  onSelected(null);
                } else {
                  onSelected(option);
                }
              }
            });
          },
          selectedColor: Color.fromRGBO(1, 80, 147, 1),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildSlider(
      RangeValues currentRange,
      RangeValues maxRange,
      String unit,
      ValueChanged<RangeValues> onChanged,
      ) {
    return Column(
      children: [
        RangeSlider(
          values: currentRange,
          min: maxRange.start,
          max: maxRange.end,
          activeColor: Color.fromRGBO(1, 80, 147, 1),
          inactiveColor: Colors.blue[100],
          divisions: 100,
          labels: RangeLabels(
            '${currentRange.start.toStringAsFixed(0)} $unit',
            '${currentRange.end.toStringAsFixed(0)} $unit',
          ),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${maxRange.start.toInt()} $unit'),
            Text('${maxRange.end.toInt()} $unit'),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isButtonClicked = true; // Change color on button click
          });

          // Optional: Reset the color back after a short delay (500ms)
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              isButtonClicked = false; // Reset the color after delay
            });
          });

          final selectedFilters = {
            "brand": selectedBrand,
            "fuelType": selectedFuelType,
            "carType": selectedCarType,
            "condition": selectedCondition,
            "location": selectedLocation,
            "minPrice": priceRange.start.round(),
            "maxPrice": priceRange.end.round(),
            "yearMin": yearRange.start.round(),
            "yearMax": yearRange.end.round(),
            "status": "active",
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilteredCarPage(filters: selectedFilters),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonClicked
              ? Colors.green // Green color when clicked
              : Color.fromRGBO(1, 80, 147, 1), // Default color
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'Show Cars',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
