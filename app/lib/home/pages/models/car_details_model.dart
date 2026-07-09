class CarDetailsModel {
  final String title;
  final String description;
  final String imageUrl;
  final int seats;
  final String power;
  final String engineSize;
  final int mileage;
  final int maxSpeed;
  final int engineOutput;
  final double suggestedPrice;
  final double resalePrice;
  final double repairCost;
  final double estimatedProfit;
  final double price;

  CarDetailsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.seats,
    required this.power,
    required this.engineSize,
    required this.mileage,
    required this.maxSpeed,
    required this.engineOutput,
    required this.suggestedPrice,
    required this.resalePrice,
    required this.repairCost,
    required this.estimatedProfit,
    required this.price,
  });

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    return CarDetailsModel(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      seats: json['seats'],
      power: json['power'],
      engineSize: json['engine_size'],
      mileage: json['mileage'],
      maxSpeed: json['max_speed'],
      engineOutput: json['engine_output'],
      suggestedPrice: json['suggested_price'].toDouble(),
      resalePrice: json['resale_price'].toDouble(),
      repairCost: json['repair_cost'].toDouble(),
      estimatedProfit: json['estimated_profit'].toDouble(),
      price: json['price'].toDouble(),
    );
  }
}
