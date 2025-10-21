import 'dart:convert';

List<FoodPlaceListResponseModel> foodPlaceListResponseModelFromJson(String str) => List<FoodPlaceListResponseModel>.from(json.decode(str).map((x) => FoodPlaceListResponseModel.fromJson(x)));

String foodPlaceListResponseModelToJson(List<FoodPlaceListResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodPlaceListResponseModel {
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
    final List<Image>? images;

    FoodPlaceListResponseModel({
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

    factory FoodPlaceListResponseModel.fromJson(Map<String, dynamic> json) => FoodPlaceListResponseModel(
        foodId: json["food_id"],
        shopName: json["shop_name"],
        address: json["address"],
        phone: json["phone"],
        openHours: json["open_hours"],
        priceRange: json["price_range"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        closeHours: json["close_hours"],
        foodName: json["food_name"],
        id: json["id"],
        food: json["food"] == null ? null : Food.fromJson(json["food"]),
        images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
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
        "created_at": createdAt?.toIso8601String(),
        "close_hours": closeHours,
        "food_name": foodName,
        "id": id,
        "food": food?.toJson(),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    };
}

class Food {
    final String? foodName;

    Food({
        this.foodName,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodName: json["food_name"],
    );

    Map<String, dynamic> toJson() => {
        "food_name": foodName,
    };
}

class Image {
    final String? imageUrl;
    final int? idFoodPlace;
    final int? idImagePlace;

    Image({
        this.imageUrl,
        this.idFoodPlace,
        this.idImagePlace,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageUrl: json["image_url"],
        idFoodPlace: json["id_food_place"],
        idImagePlace: json["id_image_place"],
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "id_food_place": idFoodPlace,
        "id_image_place": idImagePlace,
    };
}
