import 'package:mobile_apps/data/models/review/review_response_model.dart';

sealed class ReviewResultState {}

class ReviewNoneState extends ReviewResultState {}

class ReviewLoadingState extends ReviewResultState {}

class ReviewErrorState extends ReviewResultState {
  final String error;

  ReviewErrorState({required this.error});
}

class ReviewLoadedState extends ReviewResultState {
  final List<ReviewResponseModel> data;

  ReviewLoadedState({required this.data});
}
