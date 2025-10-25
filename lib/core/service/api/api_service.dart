import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps/data/models/auth/login/login_response_model.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/data/models/auth/register/register_response_model.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';
import 'package:mobile_apps/data/models/food_place/food_place_detail_response_model.dart';
import 'package:mobile_apps/data/models/main/camera/upload_response.dart';
import 'package:mobile_apps/data/models/main/food/edit_food_response.dart';
import 'package:mobile_apps/data/models/main/food/food_model.dart';
import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';
import 'package:mobile_apps/data/models/main/home/resto_list_response_models.dart';
import 'package:mobile_apps/data/models/main/profile/change_profile_response_model.dart';
import 'package:mobile_apps/data/models/review/review_response_model.dart';
import 'package:mobile_apps/data/models/review/create_review_response_model.dart';
import 'package:mobile_apps/main.dart';
import 'package:mobile_apps/presentation/static/main/navigation_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_apps/data/models/food_place/food_place_list_response_model.dart';
import 'package:http_parser/http_parser.dart';

import '../../../data/models/main/resto/create_food_place_request.dart';
import '../../../data/models/main/resto/create_food_place_response.dart';
import '../../../data/models/main/resto/create_place_wrapper.dart';
import '../../../data/models/main/resto/food_place_search_response.dart';
import '../../../data/models/main/resto/resto_food_model.dart';

class ApiService {
  static const String _baseUrl =
      "https://backend-production-81ae.up.railway.app/api";

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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
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

    print("response resto list ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("data resto ${data.length}");

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

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return FoodListResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleUnauthorized();
        throw Exception("Unauthorized - Redirecting to login");
      } else {
        throw Exception("Failed to search food list");
      }
    } catch (e) {
      print(e);
      throw Exception("Gagal menampilkan");
    }
  }

    Future<FoodListResponseModel> searchScanFood(
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

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return FoodListResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleUnauthorized();
        throw Exception("Unauthorized - Redirecting to login");
      } else {
        throw Exception("Failed to search food list");
      }
    } catch (e) {
      print(e);
      throw Exception("Gagal menampilkan");
    }
  }

  Future<UploadResponse> uploadDocument(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      const String url = "https://86ca99b84ec6.ngrok-free.app/api/classify/";

      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);

      final http.MultipartFile multiPartFile = http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: fileName,
      );

      final Map<String, String> headers = {
        "Content-type": "multipart/form-data",
      };

      request.files.add(multiPartFile);
      request.headers.addAll(headers);

      final http.StreamedResponse streamedResponse = await request.send();
      final int statusCode = streamedResponse.statusCode;
      final Uint8List responseList = await streamedResponse.stream.toBytes();
      final String responseData = String.fromCharCodes(responseList);

      if (statusCode == 200 || statusCode == 201 || statusCode == 413) {
        return UploadResponse.fromJson(jsonDecode(responseData));
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      throw Exception("Caught an error: $e");
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      throw Exception("Failed to search food");
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

    debugPrint(response.body.toString());

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

  Future<RestoPlaceModel> createFoodPlace(
    CreateFoodPlaceRequest request,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    // ============== LANGKAH TUNGGAL: INSERT DATA & GAMBAR ==============
    // Endpoint BE sekarang adalah POST /food-place dan menerima file.
    final uri = Uri.parse("$_baseUrl/food-place");
    final requestBody = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      // --- Data Fields ---
      ..fields['shop_name'] = request.shopName
      ..fields['latitude'] = request.latitude.toString()
      ..fields['longitude'] = request.longitude.toString();

    // Tambahkan field opsional
    if (request.foodId != null)
      requestBody.fields['food_id'] = request.foodId.toString();
    if (request.address != null)
      requestBody.fields['address'] = request.address!;
    if (request.phone != null) requestBody.fields['phone'] = request.phone!;
    if (request.openHours != null)
      requestBody.fields['open_hours'] = request.openHours!;
    if (request.closeHours != null)
      requestBody.fields['close_hours'] = request.closeHours!;
    if (request.priceRange != null)
      requestBody.fields['price_range'] = request.priceRange!;
    if (request.foodName != null)
      requestBody.fields['food_name'] = request.foodName!;

    // --- File Fields ---
    if (request.images != null && request.images!.isNotEmpty) {
      for (var file in request.images!) {
        final mimeType = file.path.split('.').last.toLowerCase();
        final http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(
              'images', // Nama field sesuai BE
              file.path,
              contentType: MediaType(
                'image',
                mimeType == 'png' ? 'png' : 'jpeg',
              ),
            );
        requestBody.files.add(multipartFile);
      }
    }

    final http.StreamedResponse streamedResponse = await requestBody.send();
    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // BE mengembalikan RestoPlaceModel yang sudah berisi array images terlampir.
      // Kita harus memanggil RestoPlaceModel.fromJson langsung.
      return RestoPlaceModel.fromJson(jsonDecode(response.body));
    } else {
      print(
        "Failed to create food place. Status: ${response.statusCode}, Body: ${response.body}",
      );
      final errorBody = jsonDecode(response.body);
      throw Exception(
        "Gagal membuat tempat makan: ${errorBody['detail'] ?? errorBody['error']}",
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
      Uri.parse("$_baseUrl/food-place/$id"),
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
      print(
        "Failed to delete food place. Status: ${response.statusCode}, Body: ${response.body}",
      );
      throw Exception(
        "Failed to delete food place. Status code: ${response.statusCode}",
      );
    }
  }

  Future<RestoPlaceModel> updateFoodPlace(
    int id,
    CreateFoodPlaceRequest request,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final uri = Uri.parse("$_baseUrl/edit-food-place/$id");

    final requestBody = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['shop_name'] = request.shopName
      ..fields['latitude'] = request.latitude.toString()
      ..fields['longitude'] = request.longitude.toString();

    // optional fields
    if (request.foodId != null)
      requestBody.fields['food_id'] = request.foodId.toString();
    if (request.address != null)
      requestBody.fields['address'] = request.address!;
    if (request.phone != null) requestBody.fields['phone'] = request.phone!;
    if (request.openHours != null)
      requestBody.fields['open_hours'] = request.openHours!;
    if (request.closeHours != null)
      requestBody.fields['close_hours'] = request.closeHours!;
    if (request.priceRange != null)
      requestBody.fields['price_range'] = request.priceRange!;
    if (request.foodName != null)
      requestBody.fields['food_name'] = request.foodName!;

    final http.StreamedResponse streamedResponse = await requestBody.send();
    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      // karena response {"message": "...", "data": {...}}
      return RestoPlaceModel.fromJson(jsonData['data']);
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(
        "Gagal update food place: ${errorBody['detail'] ?? 'Unknown error'}",
      );
    }
  }

  Future<List<String>> updateFoodPlaceImages(
    int idFoodPlace,
    List<File> newImages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final uri = Uri.parse("$_baseUrl/food-place/image");
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['id_food_place'] = idFoodPlace.toString();

    for (var image in newImages) {
      final ext = image.path.split('.').last.toLowerCase();
      final multipartFile = await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['urls'] != null) {
        return List<String>.from(jsonData['urls']);
      } else if (jsonData['data'] != null) {
        // handle case: API returns { data: [ { image_url: "..." }, ... ] }
        return (jsonData['data'] as List)
            .map((e) => e['image_url'] as String)
            .toList();
      } else {
        return [];
      }
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(
        "Gagal update gambar: ${errorBody['detail'] ?? 'Unknown error'}",
      );
    }
  }

  Future<List<String>> insertFoodPlaceImages(
    int idFoodPlace,
    List<File> newImages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Access Token not found. Please login.");
    }

    final uri = Uri.parse("$_baseUrl/food-place/image");
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['id_food_place'] = idFoodPlace.toString();

    for (var image in newImages) {
      final ext = image.path.split('.').last.toLowerCase();
      final multipartFile = await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType('image', ext == 'png' ? 'png' : 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['urls'] != null) {
        return List<String>.from(jsonData['urls']);
      } else if (jsonData['data'] != null) {
        // handle case: API returns { data: [ { image_url: "..." }, ... ] }
        return (jsonData['data'] as List)
            .map((e) => e['image_url'] as String)
            .toList();
      } else {
        return [];
      }
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(
        "Gagal update gambar: ${errorBody['detail'] ?? 'Unknown error'}",
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      throw Exception(
        "Gagal menambahkan makanan. [${response.statusCode}] ${response.body}",
      );
    }
  }

  Future<EditFoodResponse> updateFood({
    required String id,
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
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final uri = Uri.parse("$_baseUrl/food/$id");

    final Map<String, dynamic> body = {
      "food_name": foodName,
      if (category != null && category.isNotEmpty) "category": category,
      if (from != null && from.isNotEmpty) "from": from,
      if (desc != null && desc.isNotEmpty) "desc": desc,
      if (history != null && history.isNotEmpty) "history": history,
      if (material != null && material.isNotEmpty) "material": material,
      if (recipes != null && recipes.isNotEmpty) "recipes": recipes,
      if (timeCook != null && timeCook.isNotEmpty) "time_cook": timeCook,
      if (serving != null && serving.isNotEmpty) "serving": serving,
      if (vidioUrl != null && vidioUrl.isNotEmpty) "vidio_url": vidioUrl,
    };

    final response = await http.put(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return EditFoodResponse.fromJson(responseBody);
    } else {
      throw Exception(
        "Gagal mengedit makanan. [${response.statusCode}] ${response.body}",
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? "Failed to delete food");
      } catch (_) {
        throw Exception("Failed to delete food: ${response.statusCode}");
      }
    }
  }

  Future<List<FoodPlaceListResponseModel>> getAllFoodPlace(
    final String accessToken,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/food-place"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => FoodPlaceListResponseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load food places");
    }
  }

  Future<List<FoodPlaceListResponseModel>> getAllFoodPlaceByFoodId(
    final int foodId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/get-food-place/food/$foodId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => FoodPlaceListResponseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load food places");
    }
  }

  Future<FoodPlaceDetailResponseModel> getFoodPlaceDetailById(int id) async {
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
      return FoodPlaceDetailResponseModel.fromJson(data);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      throw Exception("Failed to get food place with id: $id");
    }
  }

  Future<FoodModel> getFoodById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return FoodModel.fromJson(data);
    } else {
      throw Exception("Failed to get food place with id: $id");
    }
  }

  Future<List<ReviewResponseModel>> getReviewByFoodId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('MY_ACCESS_TOKEN');

    final response = await http.get(
      Uri.parse("$_baseUrl/food/$id/review"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => ReviewResponseModel.fromJson(e)).toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      throw Exception("Failed to load food list");
    }
  }

  Future<CreateReviewResponseModel> createReview({
    required int idFood,
    required String reviewDesc,
    required String idUser,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('MY_ACCESS_TOKEN');

    if (accessToken == null) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }

    final uri = Uri.parse("$_baseUrl/food/$idFood/review");

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id_food": idFood,
        "review_desc": reviewDesc,
        "id_user": idUser,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return CreateReviewResponseModel.fromJson(body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await _handleUnauthorized();
      throw Exception("Unauthorized - Redirecting to login");
    } else {
      throw Exception(
        "Gagal menambahkan ulasan. [${response.statusCode}] ${response.body}",
      );
    }
  }

  Future<void> _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('MY_ACCESS_TOKEN');

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      NavigationRoute.loginRoute.path,
      (route) => false,
    );
  }
}
