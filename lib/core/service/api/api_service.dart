import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps/data/models/auth/login/login_response_model.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/data/models/auth/register/register_response_model.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';
import 'package:mobile_apps/data/models/main/food/food_model.dart';
import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';
import 'package:mobile_apps/data/models/main/home/resto_list_response_models.dart';
import 'package:mobile_apps/data/models/main/profile/change_profile_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/main/resto/create_food_place_request.dart';
import '../../../data/models/main/resto/create_food_place_response.dart';
import '../../../data/models/main/resto/food_place_search_response.dart';
import '../../../data/models/main/resto/resto_food_model.dart';

class ApiService {
  static const String _baseUrl = "https://1cb5b33c045a.ngrok-free.app/api";

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

  Future<List<FoodListResponseModel>> getFoodList(
    final String accessToken,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/food"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => FoodListResponseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load food list");
    }
  }

  Future<List<RestoListResponseModels>> getRestoList(
    final String accessToken,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/food-place"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    debugPrint("response resto list ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      debugPrint("data resto ${data.length}");

      return data.map((e) => RestoListResponseModels.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load food list");
    }
  }

  Future<FoodListResponseModel> getSearcFood(
    final String accessToken,
    final String searchFood,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/food/search?name=$searchFood"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return FoodListResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to search food list");
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Gagal menampilkan");
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
      return FoodModel.fromJson(body);
    } else {
      throw Exception("Gagal mencari makanan. Code: ${response.statusCode}");
    }
  }

  Future<List<RestoPlaceModel>> getFoodPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food-place"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RestoPlaceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load food places");
    }
  }

  Future<FoodPlaceSearchResponse> searchFoodPlace(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food-place/search?name=$name"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return FoodPlaceSearchResponse.fromJson(data);
    } else {
      throw Exception("Failed to search food places");
    }
  }

  Future<RestoPlaceModel> getFoodPlaceById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/get-food-place/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return RestoPlaceModel.fromJson(data);
    } else {
      throw Exception("Failed to get food place with id: $id");
    }
  }

  Future<CreateFoodPlaceResponse> createFoodPlace(
    CreateFoodPlaceRequest request,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final uri = Uri.parse("$_baseUrl/food-place");
    final requestBody = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['shop_name'] = request.shopName
      ..fields['latitude'] = request.latitude.toString()
      ..fields['longitude'] = request.longitude.toString();

    // Tambahkan field opsional jika tidak null
    if (request.foodId != null) {
      requestBody.fields['food_id'] = request.foodId.toString();
    }
    if (request.address != null) {
      requestBody.fields['address'] = request.address!;
    }
    if (request.phone != null) {
      requestBody.fields['phone'] = request.phone!;
    }
    if (request.openHours != null) {
      requestBody.fields['open_hours'] = request.openHours!;
    }
    if (request.closeHours != null) {
      requestBody.fields['close_hours'] = request.closeHours!;
    }
    if (request.priceRange != null) {
      requestBody.fields['price_range'] = request.priceRange!;
    }
    if (request.foodName != null) {
      requestBody.fields['food_name'] = request.foodName!;
    }

    // Tambahkan file gambar
    if (request.images != null && request.images!.isNotEmpty) {
      for (var file in request.images!) {
        // Asumsi file adalah gambar dan kita gunakan tipe image/jpeg atau bisa disesuaikan
        final http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(
              'images', // Nama field di API
              file.path,
              // contentType: MediaType('image', 'jpeg'),
            );
        requestBody.files.add(multipartFile);
      }
    }

    // Kirim request
    final http.StreamedResponse streamedResponse = await requestBody.send();
    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CreateFoodPlaceResponse.fromJson(jsonDecode(response.body));
    } else {
      // Lebih baik log atau cek body response untuk detail error dari server
      debugPrint(
        "Failed to create food place. Status: ${response.statusCode}, Body: ${response.body}",
      );
      throw Exception(
        "Failed to create food place. Status code: ${response.statusCode}",
      );
    }
  }

  Future<String> deleteFoodPlace(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final response = await http.delete(
      Uri.parse("$_baseUrl/food-places/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      // Mengambil pesan dari response body
      final Map<String, dynamic> body = jsonDecode(response.body);
      return body['message'] ?? "Food place deleted successfully";
    } else {
      // Log atau cek body response untuk detail error dari server
      debugPrint(
        "Failed to delete food place. Status: ${response.statusCode}, Body: ${response.body}",
      );
      throw Exception(
        "Failed to delete food place. Status code: ${response.statusCode}",
      );
    }
  }

  Future<CreateFoodPlaceResponse> updateFoodPlace(
    int id,
    CreateFoodPlaceRequest request,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final uri = Uri.parse("$_baseUrl/food-place/$id");

    // Menggunakan PUT method untuk update
    final requestBody = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      // Field wajib
      ..fields['shop_name'] = request.shopName
      ..fields['latitude'] = request.latitude.toString()
      ..fields['longitude'] = request.longitude.toString();

    // Tambahkan field opsional jika tidak null
    if (request.foodId != null) {
      requestBody.fields['food_id'] = request.foodId.toString();
    }
    if (request.address != null) {
      requestBody.fields['address'] = request.address!;
    }
    if (request.phone != null) {
      requestBody.fields['phone'] = request.phone!;
    }
    if (request.openHours != null) {
      requestBody.fields['open_hours'] = request.openHours!;
    }
    if (request.closeHours != null) {
      requestBody.fields['close_hours'] = request.closeHours!;
    }
    if (request.priceRange != null) {
      requestBody.fields['price_range'] = request.priceRange!;
    }
    if (request.foodName != null) {
      requestBody.fields['food_name'] = request.foodName!;
    }

    // Tambahkan file gambar baru (jika ada)
    // Berdasarkan fungsi BE Anda, jika ada file baru, file lama akan dihapus/diganti.
    if (request.images != null && request.images!.isNotEmpty) {
      for (var file in request.images!) {
        final http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(
              'images', // Nama field di API
              file.path,
              // contentType: MediaType('image', 'jpeg'),
            );
        requestBody.files.add(multipartFile);
      }
    }

    // Kirim request
    final http.StreamedResponse streamedResponse = await requestBody.send();
    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Response body berisi object food place yang sudah diupdate
      return CreateFoodPlaceResponse.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(
        "Failed to update food place. Status: ${response.statusCode}, Body: ${response.body}",
      );
      throw Exception(
        "Failed to update food place. Status code: ${response.statusCode}",
      );
    }
  }

  Future<FoodModel> createFood({
    required String foodName,
    String? category,
    String? from,
    String? desc,
    String? history,
    String? material,
    String? recipes,
    String? timeCook,
    String? serving,
    String? vidioUrl,
    List<File>? images,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final uri = Uri.parse("$_baseUrl/food");
    final request = http.MultipartRequest("POST", uri);

    // Header
    request.headers.addAll({
      "Authorization": "Bearer $accessToken",
      "Accept": "application/json",
    });

    // Form fields
    request.fields['food_name'] = foodName;
    if (category != null && category.isNotEmpty) {
      request.fields['category'] = category;
    }
    if (from != null && from.isNotEmpty) {
      request.fields['from'] = from;
    }
    if (desc != null && desc.isNotEmpty) {
      request.fields['desc'] = desc;
    }
    if (history != null && history.isNotEmpty) {
      request.fields['history'] = history;
    }
    if (material != null && material.isNotEmpty) {
      request.fields['material'] = material;
    }
    if (recipes != null && recipes.isNotEmpty) {
      request.fields['recipes'] = recipes;
    }
    if (timeCook != null && timeCook.isNotEmpty) {
      request.fields['time_cook'] = timeCook;
    }
    if (serving != null && serving.isNotEmpty) {
      request.fields['serving'] = serving;
    }
    if (vidioUrl != null && vidioUrl.isNotEmpty) {
      request.fields['vidio_url'] = vidioUrl;
    }

    // Attach images (optional)
    if (images != null && images.isNotEmpty) {
      for (final image in images) {
        final fileName = image.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            image.path,
            filename: fileName,
          ),
        );
      }
    }

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return FoodModel.fromJson(body);
    } else {
      throw Exception(
        "Gagal menambahkan makanan. [${response.statusCode}] ${response.body}",
      );
    }
  }

  Future<String> deleteFood(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.delete(
      Uri.parse("$_baseUrl/food/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      try {
        final body = jsonDecode(response.body);
        return body['message'] ?? "Food deleted successfully";
      } catch (_) {
        return "Food deleted successfully";
      }
    } else {
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? "Failed to delete food");
      } catch (_) {
        throw Exception("Failed to delete food: ${response.statusCode}");
      }
    }
  }
}
