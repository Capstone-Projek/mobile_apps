import 'dart:io';

class CreateFoodPlaceRequest {
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
  final List<File>? images;

  CreateFoodPlaceRequest({
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
    this.images,

  });
}
