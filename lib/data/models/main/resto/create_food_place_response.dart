class CreateFoodPlaceResponse {
  final int id;
  final int? foodId;
  final String shopName;
  final String? address;
  final String? phone;
  final String? openHours;
  final String? closeHours;
  final String? priceRange;
  final double latitude;
  final double longitude;
  final String? foodName;
  final List<ImageUrl> images;

  CreateFoodPlaceResponse({
    required this.id,
    this.foodId,
    required this.shopName,
    this.address,
    this.phone,
    this.openHours,
    this.closeHours,
    this.priceRange,
    required this.latitude,
    required this.longitude,
    this.foodName,
    required this.images,
  });

  factory CreateFoodPlaceResponse.fromJson(Map<String, dynamic> json) {
    return CreateFoodPlaceResponse(
      id: json['id'],
      foodId: json['food_id'],
      shopName: json['shop_name'],
      address: json['address'],
      phone: json['phone'],
      openHours: json['open_hours'],
      closeHours: json['close_hours'],
      priceRange: json['price_range'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      foodName: json['food_name'],
      images: (json['images'] as List<dynamic>)
          .map((e) => ImageUrl.fromJson(e))
          .toList(),
    );
  }
}

class ImageUrl {
  final String imageUrl;

  ImageUrl({required this.imageUrl});

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(imageUrl: json['image_url']);
  }
}
