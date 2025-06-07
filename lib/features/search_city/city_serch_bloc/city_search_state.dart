import '../data/models/city_search_model.dart';

sealed class CitySearchState {}

class CitySearchLoading extends CitySearchState {}

class CitySearchFormSate extends CitySearchState {}

class CitySearchSuccess extends CitySearchState {
  final CityModel cityModel;
  CitySearchSuccess({required this.cityModel});
}

class CitySearchFailed extends CitySearchState {
  final String errorMessage;

  CitySearchFailed({required this.errorMessage});
}
