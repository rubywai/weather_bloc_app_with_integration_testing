import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:weather_bloc_app/features/weather_detail/data/models/weather_detail_model.dart';
import 'package:weather_bloc_app/features/weather_detail/data/service/weather_detail_service.dart';
import 'package:weather_bloc_app/features/weather_detail/weather_detail_bloc/weather_detail_cubit.dart';
import 'package:weather_bloc_app/features/weather_detail/weather_detail_bloc/weather_detail_state.dart';

class MockWeatherDetailService extends Mock implements WeatherDetailService {}

void main() {
  late MockWeatherDetailService mockService;
  late WeatherDetailCubit cubit;

  setUp(() {
    mockService = MockWeatherDetailService();
    GetIt.I.registerSingleton<WeatherDetailService>(mockService);
    cubit = WeatherDetailCubit();
  });

  tearDown(() {
    GetIt.I.reset();
    cubit.close();
  });

  final fakeWeatherDetail = WeatherDetail(
    currentWeather: CurrentWeather(
      time: "2025-07-04T10:00",
      temperature: 32.5,
      weatherCode: 2,
    ),
  );

  blocTest<WeatherDetailCubit, WeatherDetailState>(
    'emits [Loading, Success] when getWeatherDetail succeeds',
    build: () {
      when(() => mockService.getWeatherDetail(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            currentWeather: any(named: 'currentWeather'),
          )).thenAnswer((_) async => fakeWeatherDetail);
      return cubit;
    },
    act: (cubit) => cubit.getWeatherDetail(latitude: 1.0, longitude: 2.0),
    expect: () => [
      isA<WeatherDetailLoading>(),
      isA<WeatherDetailSuccess>().having(
          (s) => s.detail.currentWeather.temperature, 'temperature', 32.5),
    ],
  );

  blocTest<WeatherDetailCubit, WeatherDetailState>(
    'emits [Loading, Failed] when getWeatherDetail throws',
    build: () {
      when(() => mockService.getWeatherDetail(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            currentWeather: any(named: 'currentWeather'),
          )).thenThrow(Exception('network error'));
      return cubit;
    },
    act: (cubit) => cubit.getWeatherDetail(latitude: 1.0, longitude: 2.0),
    expect: () => [
      isA<WeatherDetailLoading>(),
      isA<WeatherDetailFailed>(),
    ],
  );
}
