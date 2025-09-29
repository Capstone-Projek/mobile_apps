import 'package:mobile_apps/data/models/auth/user/user_response_model.dart';

sealed class RegisterResultState {}

class RegisterResultNoneState extends RegisterResultState {}

class RegisterResultLoadingState extends RegisterResultState {}

class RegisterResultErrorState extends RegisterResultState {
  final String error;

  RegisterResultErrorState({required this.error});
}

class RegisterResultLoadedState extends RegisterResultState {
  final UserResponseModel data;

  RegisterResultLoadedState({required this.data});
}
