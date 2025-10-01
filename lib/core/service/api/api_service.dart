import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_apps/data/models/auth/login/login_response_model.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/data/models/auth/register/register_response_model.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';

class ApiService {
  static const String _baseUrl = "http://ipComputer:4000/api";

  Future<RegisterResponseModel> registerUser(UserRegisterRequest user) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/regis"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to register");
    }
  }

  Future<LoginResponseModel> loginUser(UserLoginRequest user) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<String?> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/refresh-token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final String accessToken = body['accessToken'];
      print("Access Token berhasil diperoleh: $accessToken");
      return accessToken;
    } else {
      throw Exception("Failed to refresh accessToken");
    }
  }
}
