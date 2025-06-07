import 'package:json_annotation/json_annotation.dart';
part 'weather_detail_model.g.dart';

@JsonSerializable()
class WeatherDetail {
  @JsonKey(name: 'current_weather')
  final CurrentWeather currentWeather;

  WeatherDetail({required this.currentWeather});
  factory WeatherDetail.fromJson(Map<String, dynamic> json) =>
      _$WeatherDetailFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDetailToJson(this);
}

@JsonSerializable()
class CurrentWeather {
  final String time;
  final num temperature;
  @JsonKey(name: 'weathercode')
  final int weatherCode;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });
  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);
}
