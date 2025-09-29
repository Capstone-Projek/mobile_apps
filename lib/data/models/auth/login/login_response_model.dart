import 'package:mobile_apps/data/models/auth/user/user_response_model.dart';

class LoginResponseModel {
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserResponseModel userResponseModel;

  LoginResponseModel({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.userResponseModel,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userResponseModel: UserResponseModel.fromJson(json['user']),
    );
  }
}
