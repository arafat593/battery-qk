import 'review_model.dart';

class BuildListingCardModel {
  final String name;
  final String mainFeatures;
  final String mainSubCategories;
  final String allSprots;
  final String location;
  final String description;
  final String price;
  final String mainImage;
  final String subImage1;
  final String subImage2;
  final String subImage3;
  final String subImage4;
  final List<String> ageGroup;
  final List<String> facilities;
  final List<String> operatingHours;
  final List<String> specificItemNames;
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;
  final int id;
  final String gender;
  final String discount;

  BuildListingCardModel({
    required this.name,
    required this.mainFeatures,
    required this.allSprots,
    required this.location,
    required this.description,
    required this.price,
    required this.mainImage,
    required this.subImage1,
    required this.subImage2,
    required this.subImage3,
    required this.subImage4,
    required this.ageGroup,
    required this.facilities,
    required this.operatingHours,
    required this.specificItemNames,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    required this.id,
    required this.gender,
    required this.discount,
    required this.mainSubCategories,
  });

  factory BuildListingCardModel.fromJson(Map<String, dynamic> json) {
    var selectedMainCategories =
        json['selectedMainCategories'] as List<dynamic>? ?? [];
    var selectedSubMainCategories =
        json['selectedSubCategories'] as List<dynamic>? ?? [];

    var selectedSpecificItems =
        json['selectedSpecificItems'] as List<dynamic>? ?? [];
    var subImagesList = json['sub_images'] as List<dynamic>? ?? [];
    String subImage1 =
        (subImagesList.isNotEmpty) ? subImagesList[0] as String : '';
    String subImage2 =
        (subImagesList.length > 1) ? subImagesList[1] as String : '';
    String subImage3 =
        (subImagesList.length > 2) ? subImagesList[2] as String : '';
    String subImage4 =
        (subImagesList.length > 3) ? subImagesList[3] as String : '';

    String mainFeatures = selectedMainCategories
        .map((category) => category['name'] as String? ?? '')
        .join(', ');
    String mainSubCategories = selectedSubMainCategories
        .map((category) => category['name'] as String? ?? '')
        .join(', ');

    String allSports = selectedSpecificItems
        .map((item) => item['name'])
        .join(', ');

    var locationList = json['location'] as List<dynamic>? ?? [];
    String location = locationList.join(', ');

    List<String> ageGroup = List<String>.from(json['agegroup'] ?? []);
    List<String> facilities = List<String>.from(json['facilities'] ?? []);
    List<String> operatingHours = List<String>.from(
      json['operatingHours'] ?? [],
    );
    List<String> specificItemNames =
        selectedSpecificItems
            .map((item) => item['name'] as String? ?? '')
            .toList();
    var reviewsList = json['reviews'] as List<dynamic>? ?? [];
    List<Review> reviews =
        reviewsList.map((review) => Review.fromJson(review)).toList();
    double averageRating = json['averageRating']?.toDouble() ?? 0.0;
    int totalReviews = json['totalReviews']?.toInt() ?? 0;

    return BuildListingCardModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      mainFeatures: mainFeatures,
      location: location,
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '',
      mainImage: json['main_image'] as String? ?? '',
      subImage1: subImage1,
      subImage2: subImage2,
      subImage3: subImage3,
      subImage4: subImage4,
      ageGroup: ageGroup,
      facilities: facilities,
      operatingHours: operatingHours,
      specificItemNames: specificItemNames,
      reviews: reviews,
      averageRating: averageRating,
      totalReviews: totalReviews,
      gender: json['gender'] as String? ?? '',
      discount: json['discount'] as String? ?? '',
      mainSubCategories: mainSubCategories,
      allSprots: allSports,
    );
  }
}
