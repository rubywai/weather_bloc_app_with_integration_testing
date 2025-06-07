import '../data/models/weather_detail_model.dart';

sealed class WeatherDetailState {}

class WeatherDetailLoading extends WeatherDetailState {}

class WeatherDetailSuccess extends WeatherDetailState {
  final WeatherDetail detail;
  WeatherDetailSuccess({required this.detail});
}

class WeatherDetailFailed extends WeatherDetailState {
  final String errorMessage;
  WeatherDetailFailed({required this.errorMessage});
}
