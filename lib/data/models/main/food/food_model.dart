import 'package:mobile_apps/data/models/main/food/food_image_model.dart';

class FoodModel {
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
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deleteAt;
  final String vidioUrl;
  final List<FoodImageModel> images;

  FoodModel({
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
    this.createAt,
    this.updateAt,
    this.deleteAt,
    required this.vidioUrl,
    required this.images,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      idFood: json['id_food'] as int,
      foodName: json['food_name'] as String,
      category: json['category'] as String,
      from: json['from'] as String,
      desc: json['desc'] as String,
      history: json['history'] as String,
      material: json['material'] as String,
      recipes: json['recipes'] as String,
      timeCook: json['time_cook'] as String,
      serving: json['serving'] as String,
      createAt: json['create_at'] != null
          ? DateTime.parse(json['create_at'])
          : null,
      updateAt: json['update_at'] != null
          ? DateTime.parse(json['update_at'])
          : null,
      deleteAt: json['delete_at'] != null
          ? DateTime.parse(json['delete_at'])
          : null,
      vidioUrl: json['vidio_url'] as String,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => FoodImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_food': idFood,
      'food_name': foodName,
      'category': category,
      'from': from,
      'desc': desc,
      'history': history,
      'material': material,
      'recipes': recipes,
      'time_cook': timeCook,
      'serving': serving,
      'create_at': createAt?.toIso8601String(),
      'update_at': updateAt?.toIso8601String(),
      'delete_at': deleteAt?.toIso8601String(),
      'vidio_url': vidioUrl,
      'images': images.map((e) => e.toJson()).toList(),
    };
  }

  List<String> getMaterialList() {
    return material.split(',').map((e) => e.trim()).toList();
  }

  List<String> getRecipeSteps() {
    return recipes.split(',').map((e) => e.trim()).toList();
  }

  String? getFirstImageUrl() {
    return images.isNotEmpty ? images.first.imageUrl : null;
  }
}
