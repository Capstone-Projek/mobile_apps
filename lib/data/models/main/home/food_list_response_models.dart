import 'package:mobile_apps/data/models/main/home/image_response_models.dart';

class FoodListResponseModel {
  int idFood;
  String foodName;
  String category;
  String from;
  String desc;
  String history;
  String material;
  String recipes;
  String timeCook;
  String serving;
  dynamic createAt;
  dynamic updateAt;
  dynamic deleteAt;
  String vidioUrl;
  List<FoodImage> images;

  FoodListResponseModel({
    required this.idFood,
    required this.foodName,
    required this.category,
    required this.from,
    required this.desc,
    required this.history,
    required this.material,
    required this.recipes,
    required this.timeCook,
    required this.serving,
    required this.createAt,
    required this.updateAt,
    required this.deleteAt,
    required this.vidioUrl,
    required this.images,
  });

  factory FoodListResponseModel.fromJson(Map<String, dynamic> json) =>
      FoodListResponseModel(
        idFood: json["id_food"],
        foodName: json["food_name"],
        category: json["category"],
        from: json["from"],
        desc: json["desc"],
        history: json["history"],
        material: json["material"],
        recipes: json["recipes"],
        timeCook: json["time_cook"],
        serving: json["serving"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        deleteAt: json["delete_at"],
        vidioUrl: json["vidio_url"],
        images: json["images"] == null
            ? []
            : List<FoodImage>.from(
                json["images"].map((x) => FoodImage.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "id_food": idFood,
    "food_name": foodName,
    "category": category,
    "from": from,
    "desc": desc,
    "history": history,
    "material": material,
    "recipes": recipes,
    "time_cook": timeCook,
    "serving": serving,
    "create_at": createAt,
    "update_at": updateAt,
    "delete_at": deleteAt,
    "vidio_url": vidioUrl,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}
