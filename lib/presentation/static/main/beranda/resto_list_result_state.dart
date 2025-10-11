import 'package:mobile_apps/data/models/main/home/resto_list_response_models.dart';

sealed class RestoListResultState {}

class RestoListNoneState extends RestoListResultState {}

class RestoListLoadingState extends RestoListResultState {}

class RestoListErrorState extends RestoListResultState {
  final String error;

  RestoListErrorState({required this.error});
}

class RestoListLoadedState extends RestoListResultState {
  final List<RestoListResponseModels> data;

  RestoListLoadedState({required this.data});
}
