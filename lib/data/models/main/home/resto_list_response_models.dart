class RestoListResponseModels {
  final int foodId;
  final String shopName;
  final String address;
  final String? phone;
  final String openHours;
  final String priceRange;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String closeHours;
  final String foodName;
  final int id;
  final Food food;
  final Images images;

  RestoListResponseModels({
    required this.foodId,
    required this.shopName,
    required this.address,
    this.phone,
    required this.openHours,
    required this.priceRange,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.closeHours,
    required this.foodName,
    required this.id,
    required this.food,
    required this.images,
  });

  factory RestoListResponseModels.fromJson(Map<String, dynamic> json) =>
      RestoListResponseModels(
        foodId: json["food_id"],
        shopName: json["shop_name"] ?? '',
        address: json["address"] ?? '',
        phone: json["phone"],
        openHours: json["open_hours"] ?? '',
        priceRange: json["price_range"] ?? '',
        latitude: (json["latitude"] ?? 0).toDouble(),
        longitude: (json["longitude"] ?? 0).toDouble(),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        closeHours: json["close_hours"] ?? '',
        foodName: json["food_name"] ?? '',
        id: json["id"],
        food: Food.fromJson(json["food"]),
        images: json["images"] != null
            ? Images.fromJson(json["images"])
            : Images(imageUrl: '', idImagePlace: 0),
      );

  Map<String, dynamic> toJson() => {
    "food_id": foodId,
    "shop_name": shopName,
    "address": address,
    "phone": phone,
    "open_hours": openHours,
    "price_range": priceRange,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "close_hours": closeHours,
    "food_name": foodName,
    "id": id,
    "food": food.toJson(),
    "images": images.toJson(),
  };
}

class Food {
  final String foodName;

  Food({required this.foodName});

  factory Food.fromJson(Map<String, dynamic> json) =>
      Food(foodName: json["food_name"] ?? '');

  Map<String, dynamic> toJson() => {"food_name": foodName};
}

class Images {
  final String imageUrl;
  final int idImagePlace;

  Images({required this.imageUrl, required this.idImagePlace});

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    imageUrl: json["image_url"] ?? '',
    idImagePlace: json["id_image_place"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "id_image_place": idImagePlace,
  };
}
