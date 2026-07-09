class CarDetailsModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String make;
  final String brand;
  final String model;
  final String fuelType;
  final String trim;
  final int year;
  final String status;

  final int price;
  final String currency;

  final String image;
  final List<String> images;

  final int mileage;

  final CarSpecs specs;
  final SellerInfo sellerInfo;
  final CarMetrics metrics;
  final CarLocation location;
  final CarSource source;

  final String createdAt;
  final String updatedAt;

  CarDetailsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.make,
    required this.brand,
    required this.model,
    required this.trim,
    required this.fuelType,
    required this.year,
    required this.status,
    required this.price,
    required this.currency,
    required this.image,
    required this.images,
    required this.mileage,
    required this.specs,
    required this.sellerInfo,
    required this.metrics,
    required this.location,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarDetailsModel.fromJson(Map<String, dynamic> json) {
    int p(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    return CarDetailsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      make: json['make'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      trim: json['trim'] ?? '',
      fuelType: json['fuelType'] ?? '',
      year: p(json['year']),
      status: json['status'] ?? '',
      price: p(json['price']),
      currency: json['currency'] ?? '',
      image: json['image'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      mileage: p(json['mileage']),
      specs: CarSpecs.fromJson(json['specs'] ?? {}),
      sellerInfo: SellerInfo.fromJson(json['sellerInfo'] ?? {}),
      metrics: CarMetrics.fromJson(json['metrics'] ?? {}),
      location: CarLocation.fromJson(json['location'] ?? {}),
      source: CarSource.fromJson(json['source'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CarSpecs {
  final String engineSize;
  final String power;
  final String gearbox;
  final String gears;
  final String cylinders;
  final String fuelConsumption;
  final String emissions;
  final String emptyWeight;
  final String firstRegistration;
  final int doors;
  final int seats;

  CarSpecs({
    required this.engineSize,
    required this.power,
    required this.gearbox,
    required this.gears,
    required this.cylinders,
    required this.fuelConsumption,
    required this.emissions,
    required this.emptyWeight,
    required this.firstRegistration,
    required this.doors,
    required this.seats,
  });

  factory CarSpecs.fromJson(Map<String, dynamic> json) {
    int p(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    return CarSpecs(
      engineSize: json['engineSize'] ?? '',
      power: json['power'] ?? '',
      gearbox: json['gearbox'] ?? '',
      gears: json['gears'] ?? '',
      cylinders: json['cylinders'] ?? '',
      fuelConsumption: json['fuelConsumption'] ?? '',
      emissions: json['emissions'] ?? '',
      emptyWeight: json['emptyWeight'] ?? '',
      firstRegistration: json['firstRegistration'] ?? '',
      doors: p(json['doors']),
      seats: p(json['seats']),
    );
  }
}

class SellerInfo {
  final String companyName;
  final String contactName;
  final String location;
  final List<String> phone;

  SellerInfo({
    required this.companyName,
    required this.contactName,
    required this.location,
    required this.phone,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      companyName: json['companyName'] ?? '',
      contactName: json['contactName'] ?? '',
      location: json['location'] ?? '',
      phone: (json['phone'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class CarMetrics {
  final int views;
  final int saves;
  final int shares;
  final int leadCount;

  CarMetrics({
    required this.views,
    required this.saves,
    required this.shares,
    required this.leadCount,
  });

  factory CarMetrics.fromJson(Map<String, dynamic> json) {
    int p(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    return CarMetrics(
      views: p(json['views']),
      saves: p(json['saves']),
      shares: p(json['shares']),
      leadCount: p(json['leadCount']),
    );
  }
}

class CarLocation {
  final String city;
  final String country;

  CarLocation({
    required this.city,
    required this.country,
  });

  factory CarLocation.fromJson(Map<String, dynamic> json) {
    return CarLocation(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class CarSource {
  final String type;
  final String sourceId;
  final String importedAt;

  CarSource({
    required this.type,
    required this.sourceId,
    required this.importedAt,
  });

  factory CarSource.fromJson(Map<String, dynamic> json) {
    return CarSource(
      type: json['type'] ?? '',
      sourceId: json['sourceId'] ?? '',
      importedAt: json['importedAt'] ?? '',
    );
  }
}
