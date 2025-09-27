import 'package:mobile_apps/data/models/user_response_model.dart';

class RegisterResponseModel {
  final String message;
  final UserResponseModel userResponseModel;

  RegisterResponseModel({
    required this.message,
    required this.userResponseModel,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'],
      userResponseModel: UserResponseModel.fromJson(json['user']),
    );
  }
}
