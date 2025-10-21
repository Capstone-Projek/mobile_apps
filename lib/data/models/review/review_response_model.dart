// To parse this JSON data, do
//
//     final reviewResponseModel = reviewResponseModelFromJson(jsonString);

import 'dart:convert';

List<ReviewResponseModel> reviewResponseModelFromJson(String str) => List<ReviewResponseModel>.from(json.decode(str).map((x) => ReviewResponseModel.fromJson(x)));

String reviewResponseModelToJson(List<ReviewResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewResponseModel {
    final int idReview;
    final int idFood;
    final String reviewDesc;
    final int idUser;
    final User user;

    ReviewResponseModel({
        required this.idReview,
        required this.idFood,
        required this.reviewDesc,
        required this.idUser,
        required this.user,
    });

    factory ReviewResponseModel.fromJson(Map<String, dynamic> json) => ReviewResponseModel(
        idReview: json["id_review"],
        idFood: json["id_food"],
        reviewDesc: json["review_desc"],
        idUser: json["id_user"],
        user: User.fromJson(json["user"]),
    );


    Map<String, dynamic> toJson() => {
        "id_review": idReview,
        "id_food": idFood,
        "review_desc": reviewDesc,
        "id_user": idUser,
        "user": user.toJson(),
    };
}

class User {
    final String name;
    final String email;

    User({
        required this.name,
        required this.email,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
    };
}
