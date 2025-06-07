// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDetail _$WeatherDetailFromJson(Map<String, dynamic> json) =>
    WeatherDetail(
      currentWeather: CurrentWeather.fromJson(
          json['current_weather'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDetailToJson(WeatherDetail instance) =>
    <String, dynamic>{
      'current_weather': instance.currentWeather,
    };

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      time: json['time'] as String,
      temperature: json['temperature'] as num,
      weatherCode: (json['weathercode'] as num).toInt(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature': instance.temperature,
      'weathercode': instance.weatherCode,
    };
