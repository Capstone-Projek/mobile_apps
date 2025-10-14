class EditFoodResponse {
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

  EditFoodResponse({
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
  });

  factory EditFoodResponse.fromJson(Map<String, dynamic> json) {
    return EditFoodResponse(
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
      createAt: json['create_at'] != null
          ? DateTime.tryParse(json['create_at'])
          : null,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'])
          : null,
      deleteAt: json['delete_at'] != null
          ? DateTime.tryParse(json['delete_at'])
          : null,
      vidioUrl: json['vidio_url'] ?? '',
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
    };
  }
}
