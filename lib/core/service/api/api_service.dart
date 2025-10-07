import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_apps/data/models/auth/login/login_response_model.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/data/models/auth/register/register_response_model.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';
import 'package:mobile_apps/data/models/main/food/food_model.dart';
import 'package:mobile_apps/data/models/main/profile/change_profile_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = "https://c4029c53f602.ngrok-free.app/api";

  Future<RegisterResponseModel> registerUser(UserRegisterRequest user) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/regis"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final String accessToken = body['accessToken'];
      return accessToken;
    } else {
      throw Exception("Failed to refresh accessToken");
    }
  }

  Future<ChangeProfileResponseModel> changeProfile(
    String name,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.put(
      Uri.parse("$_baseUrl/user/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"name": name, "email": email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChangeProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to change profile");
    }
  }

  Future<List<FoodModel>> getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> body = jsonDecode(response.body);
      final List<FoodModel> foods = body
          .map((e) => FoodModel.fromJson(e))
          .toList();
      return foods;
    } else {
      throw Exception("Failed to get foods");
    }
  }

  Future<FoodModel> searchFood(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food/search?name=$name"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final FoodModel food = FoodModel.fromJson(body);
      return food;
    } else {
      throw Exception("Failed to search food");
    }
  }
}
