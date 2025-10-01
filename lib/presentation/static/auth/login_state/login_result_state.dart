import 'package:mobile_apps/data/models/auth/user/user_response_model.dart';

sealed class LoginResultState {}

class LoginResultNoneState extends LoginResultState {}

class LoginResultLoadingState extends LoginResultState {}

class LoginResultErrorState extends LoginResultState {
  final String error;

  LoginResultErrorState({required this.error});
}

class LoginResultLoadedState extends LoginResultState {
  final UserResponseModel dataUser;
  final String accessToken;
  final String refreshToken;

  LoginResultLoadedState({
    required this.dataUser,
    required this.accessToken,
    required this.refreshToken,
  });
}
