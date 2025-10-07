class FoodImageModel {
  final int idImage;
  final int idFood;
  final String imageUrl;
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deleteAt;

  FoodImageModel({
    required this.idImage,
    required this.idFood,
    required this.imageUrl,
    this.createAt,
    this.updateAt,
    this.deleteAt,
  });

  factory FoodImageModel.fromJson(Map<String, dynamic> json) {
    return FoodImageModel(
      idImage: json['id_image'] as int,
      idFood: json['id_food'] as int,
      imageUrl: json['image_url'] as String,
      createAt: json['create_at'] != null
          ? DateTime.parse(json['create_at'])
          : null,
      updateAt: json['update_at'] != null
          ? DateTime.parse(json['update_at'])
          : null,
      deleteAt: json['delete_at'] != null
          ? DateTime.parse(json['delete_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_image': idImage,
      'id_food': idFood,
      'image_url': imageUrl,
      'create_at': createAt?.toIso8601String(),
      'update_at': updateAt?.toIso8601String(),
      'delete_at': deleteAt?.toIso8601String(),
    };
  }

  FoodImageModel copyWith({
    int? idImage,
    int? idFood,
    String? imageUrl,
    DateTime? createAt,
    DateTime? updateAt,
    DateTime? deleteAt,
  }) {
    return FoodImageModel(
      idImage: idImage ?? this.idImage,
      idFood: idFood ?? this.idFood,
      imageUrl: imageUrl ?? this.imageUrl,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }
}
