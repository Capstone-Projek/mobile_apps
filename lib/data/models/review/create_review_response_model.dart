import 'dart:convert';

CreateReviewResponseModel createReviewResponseModelFromJson(String str) => CreateReviewResponseModel.fromJson(json.decode(str));

String createReviewResponseModelToJson(CreateReviewResponseModel data) => json.encode(data.toJson());

class CreateReviewResponseModel {
    final int idReview;
    final int idFood;
    final String reviewDesc;
    final int idUser;

    CreateReviewResponseModel({
        required this.idReview,
        required this.idFood,
        required this.reviewDesc,
        required this.idUser,
    });

    factory CreateReviewResponseModel.fromJson(Map<String, dynamic> json) => CreateReviewResponseModel(
        idReview: json["id_review"],
        idFood: json["id_food"],
        reviewDesc: json["review_desc"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id_review": idReview,
        "id_food": idFood,
        "review_desc": reviewDesc,
        "id_user": idUser,
    };
}
