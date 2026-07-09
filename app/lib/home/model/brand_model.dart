class BrandModel {
  final String id;
  final String name;
  final String image;
  final String status;
  final bool isDeleted;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.isDeleted,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
