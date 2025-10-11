class FoodImageModel {
  final int idFood;
  final String imageUrl;

  FoodImageModel({required this.idFood, required this.imageUrl});

  factory FoodImageModel.fromJson(Map<String, dynamic> json) {
    return FoodImageModel(
      idFood: json['id_food'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_food': idFood, 'image_url': imageUrl};
  }

  FoodImageModel copyWith({int? idFood, String? imageUrl}) {
    return FoodImageModel(
      idFood: idFood ?? this.idFood,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
