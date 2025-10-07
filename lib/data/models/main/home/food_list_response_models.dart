import 'package:mobile_apps/data/models/main/home/image_response_models.dart';

class FoodListResponseModel {
  final int idFood;
  final String foodName;
  final String category;
  final String from;
  final String desc;
  final String history;
  final String material;
  final String recipes;
  final String timeCook;
  final String serving;
  final String? vidioUrl;
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deleteAt;
  final List<FoodImage>? images;

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
    this.vidioUrl,
    this.createAt,
    this.updateAt,
    this.deleteAt,
    this.images,
  });

  factory FoodListResponseModel.fromJson(Map<String, dynamic> json) {
    return FoodListResponseModel(
      idFood: json['id_food'] ?? 0,
      foodName: json['food_name'] ?? '',
      category: json['category'] ?? '',
      from: json['from'] ?? '',
      desc: json['desc'] ?? '',
      history: json['history'] ?? '',
      material: json['material'] ?? '',
      recipes: json['recipes'] ?? '',
      timeCook: json['time_cook'] ?? '',
      serving: json['serving'] ?? '',
      vidioUrl: json['vidio_url'],
      createAt: json['create_at'] != null
          ? DateTime.tryParse(json['create_at'])
          : null,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'])
          : null,
      deleteAt: json['delete_at'] != null
          ? DateTime.tryParse(json['delete_at'])
          : null,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => FoodImage.fromJson(e))
          .toList(),
    );
  }
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
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}
