class FoodImage {
  int idImage;
  int idFood;
  String imageUrl;
  dynamic createAt;
  dynamic updateAt;
  dynamic deleteAt;

  FoodImage({
    required this.idImage,
    required this.idFood,
    required this.imageUrl,
    required this.createAt,
    required this.updateAt,
    required this.deleteAt,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) => FoodImage(
    idImage: json["id_image"],
    idFood: json["id_food"],
    imageUrl: json["image_url"],
    createAt: json["create_at"],
    updateAt: json["update_at"],
    deleteAt: json["delete_at"],
  );

  Map<String, dynamic> toJson() => {
    "id_image": idImage,
    "id_food": idFood,
    "image_url": imageUrl,
    "create_at": createAt,
    "update_at": updateAt,
    "delete_at": deleteAt,
  };
}
