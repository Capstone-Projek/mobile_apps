import 'package:mobile_apps/data/models/review/create_review_response_model.dart';

sealed class CreateReviewResultState {}

class CreateReviewNoneState extends CreateReviewResultState {}

class CreateReviewLoadingState extends CreateReviewResultState {}

class CreateReviewErrorState extends CreateReviewResultState {
  final String error;

  CreateReviewErrorState({required this.error});
}

class CreateReviewLoadedState extends CreateReviewResultState {
  final List<CreateReviewResponseModel> data;

  CreateReviewLoadedState({required this.data});
}
