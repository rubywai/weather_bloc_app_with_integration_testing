import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:weather_bloc_app/features/weather_detail/data/service/weather_detail_service.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockDio mockDio;
  late WeatherDetailService service;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    service = WeatherDetailService(mockDio);
  });

  test('should construct WeatherDetailService', () {
    final dio = Dio();
    final instance = WeatherDetailService(dio);
    expect(instance, isA<WeatherDetailService>());
  });

  test('getWeatherDetail should return parsed WeatherDetail', () async {
    final responseJson = {
      "current_weather": {
        "time": "2025-07-04T10:00",
        "temperature": 32.5,
        "weathercode": 2
      }
    };

    final response = Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: ''),
      data: responseJson,
      statusCode: 200,
    );

    when(() => mockDio.fetch<Map<String, dynamic>>(any()))
        .thenAnswer((_) async => response);

    final result = await service.getWeatherDetail(
      latitude: 1.0,
      longitude: 2.0,
      currentWeather: true,
    );

    expect(result.currentWeather.temperature, 32.5);
    expect(result.currentWeather.time, "2025-07-04T10:00");
    expect(result.currentWeather.weatherCode, 2);
  });
}
