class ListingModel {
  final int? id;
  final String? name;
  final String? price;
  final String? mainImage;
  final List<String>? subImages;
  final List<String>? agegroup;
  final List<String>? location;
  final List<String>? facilities;
  final List<String>? operatingHours;
  final bool? isActive;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ListingModel({
    this.id,
    this.name,
    this.price,
    this.mainImage,
    this.subImages,
    this.agegroup,
    this.location,
    this.facilities,
    this.operatingHours,
    this.isActive,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      mainImage: json['main_image'],
      subImages: (json['sub_images'] as List?)?.map((e) => e.toString()).toList(),
      agegroup: (json['agegroup'] as List?)?.map((e) => e.toString()).toList(),
      location: (json['location'] as List?)?.map((e) => e.toString()).toList(),
      facilities: (json['facilities'] as List?)?.map((e) => e.toString()).toList(),
      operatingHours: (json['operatingHours'] as List?)?.map((e) => e.toString()).toList(),
      isActive: json['isActive'],
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'main_image': mainImage,
    'sub_images': subImages,
    'agegroup': agegroup,
    'location': location,
    'facilities': facilities,
    'operatingHours': operatingHours,
    'isActive': isActive,
    'description': description,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'ListingModel(name: $name, price: $price)';
  }
}
