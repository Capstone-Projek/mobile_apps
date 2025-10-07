import 'package:mobile_apps/data/models/auth/user/user_response_model.dart';

sealed class ChangeProfileResultState {}

class ChangeProfileResultNoneState extends ChangeProfileResultState {}

class ChangeProfileResultLoadingState extends ChangeProfileResultState {}

class ChangeProfileResultErrorState extends ChangeProfileResultState {
  final String error;

  ChangeProfileResultErrorState({required this.error});
}

class ChangeProfileResultLoadedState extends ChangeProfileResultState {
  final String message;
  final UserResponseModel data;

  ChangeProfileResultLoadedState({required this.message, required this.data});
}
