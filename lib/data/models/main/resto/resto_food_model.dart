class RestoPlaceModel {
  final int id;
  final int? foodId; // ⭐️ Dibuat nullable di field
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
  final List<ImageInfo> images;

  RestoPlaceModel({
    required this.id,
    this.foodId, // ⭐️ Dibuat nullable di konstruktor
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
    required this.images,
  });

  factory RestoPlaceModel.fromJson(Map<String, dynamic> json) {
    return RestoPlaceModel(
      // ✅ Perbaikan: Gunakan as int? untuk handle null di BE
      id: json['id'] as int? ?? 0,
      foodId: json['food_id'] as int?, // foodId boleh null (sesuai DB)

      shopName: json['shop_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      openHours: json['open_hours'] as String? ?? '',
      closeHours: json['close_hours'] as String? ?? '',
      priceRange: json['price_range'] as String? ?? '',

      // ✅ Sudah Benar: as num? untuk double
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,

      createdAt: json['created_at'] as String? ?? '',
      foodName: json['food_name'] as String? ?? '',

      food: json['food'] != null
          ? FoodInfo.fromJson(json['food'] as Map<String, dynamic>)
          : null,

      // ✅ Sudah Benar: Menggunakan List<ImageInfo>
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  RestoPlaceModel copyWith({
    List<ImageInfo>? images,
  }) {
    return RestoPlaceModel(
      id: id,
      foodId: foodId,
      shopName: shopName,
      address: address,
      phone: phone,
      openHours: openHours,
      closeHours: closeHours,
      priceRange: priceRange,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      foodName: foodName,
      food: food,
      images: images ?? this.images,
    );
  }
}

// ------------------------------------------------------------------

class FoodInfo {
  final String foodName;

  FoodInfo({required this.foodName});

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      foodName: json['food_name'] as String? ?? '',
    );
  }
}

// ------------------------------------------------------------------

class ImageInfo {
  final String imageUrl;
  final int idFoodPlace;
  final int idImagePlace;

  ImageInfo({
    required this.imageUrl,
    required this.idFoodPlace,
    required this.idImagePlace,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      imageUrl: json['image_url'] as String? ?? '',
      // ✅ Sudah Benar: Menggunakan as int? ?? 0 untuk aman dari null
      idFoodPlace: json['id_food_place'] as int? ?? 0,
      idImagePlace: json['id_image_place'] as int? ?? 0,
    );
  }
}