import 'package:flutter/material.dart';

class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Cars')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.directions_car),
          title: Text('Car #$i'),
          subtitle: const Text('Tap to view details'),
        ),
      ),
    );
  }
}
