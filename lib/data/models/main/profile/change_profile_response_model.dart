import 'package:mobile_apps/data/models/auth/user/user_response_model.dart';

class ChangeProfileResponseModel {
  final String message;
  final UserResponseModel data;

  ChangeProfileResponseModel({required this.message, required this.data});

  factory ChangeProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangeProfileResponseModel(
        message: json["message"],
        data: UserResponseModel.fromJson(json["user"]),
      );
}
