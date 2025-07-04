import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bloc_app/features/weather_detail/data/models/weather_detail_model.dart';

void main() {
  test('WeatherDetail fromJson and toJson test', () {
    const jsonString = '''
    {
      "current_weather": {
        "time": "2025-07-04T10:00",
        "temperature": 32.5,
        "weathercode": 2
      }
    }
    ''';

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // ✅ Deserialize
    final weatherDetail = WeatherDetail.fromJson(jsonMap);
    expect(weatherDetail.currentWeather.temperature, 32.5);
    expect(weatherDetail.currentWeather.time, "2025-07-04T10:00");
    expect(weatherDetail.currentWeather.weatherCode, 2);

    // ✅ Serialize
    final currentWeatherJson = weatherDetail.currentWeather.toJson();

    expect(currentWeatherJson['temperature'], 32.5);
    expect(currentWeatherJson['time'], "2025-07-04T10:00");
    expect(currentWeatherJson['weathercode'], 2);
  });
}
