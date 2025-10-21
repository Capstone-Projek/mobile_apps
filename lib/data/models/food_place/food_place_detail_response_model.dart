class FoodPlaceDetailResponseModel {
  final int id;
  final int foodId;
  final String shopName;
  final String address;
  final String phone;
  final String openHours;
  final String closeHours;
  final String priceRange;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String foodName;
  final FoodInfo? food;
  final List<ImageInfo>? images;

  FoodPlaceDetailResponseModel({
    required this.id,
    required this.foodId,
    required this.shopName,
    required this.address,
    required this.phone,
    required this.openHours,
    required this.closeHours,
    required this.priceRange,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.foodName,
    this.food,
    this.images,
  });

  factory FoodPlaceDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return FoodPlaceDetailResponseModel(
      id: json['id'],
      foodId: json['food_id'],
      shopName: json['shop_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      openHours: json['open_hours'] ?? '',
      closeHours: json['close_hours'] ?? '',
      priceRange: json['price_range'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['created_at'] ?? '',
      foodName: json['food_name'] ?? '',
      food: json['food'] != null ? FoodInfo.fromJson(json['food']) : null,
      images: json['images'] != null
          ? List<ImageInfo>.from(
              json['images'].map((x) => ImageInfo.fromJson(x)))
          : [],
    );
  }
}

class FoodInfo {
  final String foodName;

  FoodInfo({required this.foodName});

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(foodName: json['food_name'] ?? '');
  }
}

class ImageInfo {
  final String imageUrl;
  final int? idFoodPlace;
  final int idImagePlace;

  ImageInfo({
    required this.imageUrl,
    this.idFoodPlace,
    required this.idImagePlace,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      imageUrl: json['image_url'] ?? '',
      idFoodPlace: json['id_food_place'],
      idImagePlace: json['id_image_place'] ?? 0,
    );
  }
}
