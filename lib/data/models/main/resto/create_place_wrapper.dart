// ⭐️ MODEL BARU: Wrapper untuk response dari /food-place (Langkah 1)
import 'package:mobile_apps/data/models/main/resto/resto_food_model.dart';
import 'dart:convert';

class CreatePlaceWrapper {
  final String message;
  final RestoPlaceModel data;

  CreatePlaceWrapper({required this.message, required this.data});

  factory CreatePlaceWrapper.fromJson(Map<String, dynamic> json) {
    return CreatePlaceWrapper(
      message: json['message'] as String,
      // Memastikan 'data' di-parse sebagai RestoPlaceModel
      data: RestoPlaceModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

// ❌ Hapus atau ganti nama CreateFoodPlaceResponse lama Anda,
//    karena model itu tidak merepresentasikan struktur response BE yang baru.