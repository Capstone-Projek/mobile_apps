class FoodImage {
  int idFood;
  String imageUrl;
  
  FoodImage({
    required this.idFood,
    required this.imageUrl,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) => FoodImage(
    idFood: json["id_food"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id_food": idFood,
    "image_url": imageUrl,
  };
}
