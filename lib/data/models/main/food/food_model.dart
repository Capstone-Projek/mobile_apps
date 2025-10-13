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
      idFood: json['id_food'] is int
          ? json['id_food']
          : int.tryParse(json['id_food']?.toString() ?? '0') ?? 0,
      foodName: json['food_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      history: json['history']?.toString() ?? '',
      material: json['material']?.toString() ?? '',
      recipes: json['recipes']?.toString() ?? '',
      timeCook: json['time_cook']?.toString() ?? '',
      serving: json['serving']?.toString() ?? '',
      createAt:
          json['create_at'] != null && json['create_at'].toString().isNotEmpty
          ? DateTime.tryParse(json['create_at'].toString())
          : null,
      updateAt:
          json['update_at'] != null && json['update_at'].toString().isNotEmpty
          ? DateTime.tryParse(json['update_at'].toString())
          : null,
      deleteAt:
          json['delete_at'] != null && json['delete_at'].toString().isNotEmpty
          ? DateTime.tryParse(json['delete_at'].toString())
          : null,
      vidioUrl: json['vidio_url']?.toString() ?? '',
      images:
          (json['images'] as List?)
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

  List<String> getMaterialList() =>
      material.split(',').map((e) => e.trim()).toList();

  List<String> getRecipeSteps() =>
      recipes.split(',').map((e) => e.trim()).toList();

  String? getFirstImageUrl() =>
      images.isNotEmpty ? images.first.imageUrl : null;
}
