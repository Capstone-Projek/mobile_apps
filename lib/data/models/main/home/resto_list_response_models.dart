class RestoListResponseModels {
  final int? foodId;
  final String? shopName;
  final String? address;
  final String? phone;
  final String? openHours;
  final String? priceRange;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final String? closeHours;
  final String? foodName;
  final int? id;
  final Food? food;
  final List<Images>? images;

  RestoListResponseModels({
    this.foodId,
    this.shopName,
    this.address,
    this.phone,
    this.openHours,
    this.priceRange,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.closeHours,
    this.foodName,
    this.id,
    this.food,
    this.images,
  });

  factory RestoListResponseModels.fromJson(Map<String, dynamic> json) {
    return RestoListResponseModels(
      foodId: json["food_id"],
      shopName: json["shop_name"],
      address: json["address"],
      phone: json["phone"],
      openHours: json["open_hours"],
      priceRange: json["price_range"],
      latitude: (json["latitude"] != null)
          ? (json["latitude"] as num).toDouble()
          : null,
      longitude: (json["longitude"] != null)
          ? (json["longitude"] as num).toDouble()
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      closeHours: json["close_hours"],
      foodName: json["food_name"],
      id: json["id"],
      food: json["food"] != null ? Food.fromJson(json["food"]) : null,
      images: json["images"] != null
          ? (json["images"] as List).map((e) => Images.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "food_id": foodId,
    "shop_name": shopName,
    "address": address,
    "phone": phone,
    "open_hours": openHours,
    "price_range": priceRange,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "close_hours": closeHours,
    "food_name": foodName,
    "id": id,
    "food": food?.toJson(),
    "images": images?.map((e) => e.toJson()).toList(),
  };
}

class Food {
  final String? foodName;

  Food({this.foodName});

  factory Food.fromJson(Map<String, dynamic> json) =>
      Food(foodName: json["food_name"]);

  Map<String, dynamic> toJson() => {"food_name": foodName};
}

class Images {
  final String? imageUrl;
  final int? idImagePlace;
  final int? idFoodPlace;

  Images({this.imageUrl, this.idImagePlace, this.idFoodPlace});

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    imageUrl: json["image_url"],
    idImagePlace: json["id_image_place"],
    idFoodPlace: json["id_food_place"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "id_image_place": idImagePlace,
    "id_food_place": idFoodPlace,
  };
}
