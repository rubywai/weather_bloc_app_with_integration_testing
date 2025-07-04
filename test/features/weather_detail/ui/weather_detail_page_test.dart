import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_bloc_app/features/weather_detail/ui/weather_detail_page.dart';
import 'package:weather_bloc_app/features/weather_detail/data/models/weather_detail_model.dart';
import 'package:weather_bloc_app/features/weather_detail/weather_detail_bloc/weather_detail_cubit.dart';
import 'package:weather_bloc_app/features/weather_detail/weather_detail_bloc/weather_detail_state.dart';

class MockWeatherDetailCubit extends Mock implements WeatherDetailCubit {}

void main() {
  late MockWeatherDetailCubit mockCubit;

  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<WeatherDetailCubit>.value(
        value: mockCubit,
        child: child,
      ),
    );
  }

  setUp(() {
    mockCubit = MockWeatherDetailCubit();
  });

  testWidgets('displays loading indicator when state is WeatherDetailLoading',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(WeatherDetailLoading());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.getWeatherDetail(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget(const WeatherDetailPage(
      name: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
    )));

    await tester.pump(); // trigger postFrameCallback

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays weather data on WeatherDetailSuccess',
      (WidgetTester tester) async {
    final detail = WeatherDetail(
      currentWeather: CurrentWeather(
        time: "2025-07-04T10:00",
        temperature: 30.0,
        weatherCode: 2,
      ),
    );

    when(() => mockCubit.state)
        .thenReturn(WeatherDetailSuccess(detail: detail));
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.getWeatherDetail(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget(const WeatherDetailPage(
      name: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
    )));

    await tester.pump();

    expect(find.text('Singapore'), findsOneWidget);
    expect(find.textContaining('Updated At'), findsOneWidget);
    expect(find.text('☁️'), findsOneWidget);
    expect(find.text('30.0°C'), findsOneWidget);
    expect(find.text('Cloud'), findsOneWidget);
  });

  testWidgets('displays error message and retry button on WeatherDetailFailed',
      (WidgetTester tester) async {
    when(() => mockCubit.state)
        .thenReturn(WeatherDetailFailed(errorMessage: 'Something wrong'));
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.getWeatherDetail(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget(const WeatherDetailPage(
      name: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
    )));

    await tester.pump();

    expect(find.text('Something wrong'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    verify(() => mockCubit.getWeatherDetail(
          latitude: 1.3521,
          longitude: 103.8198,
        )).called(2); // once from initState, once from retry
  });

  testWidgets('handles invalid datetime in WeatherDetailSuccess',
      (WidgetTester tester) async {
    final detail = WeatherDetail(
      currentWeather: CurrentWeather(
        time: "invalid-date-format",
        temperature: 28.5,
        weatherCode: 1,
      ),
    );

    when(() => mockCubit.state)
        .thenReturn(WeatherDetailSuccess(detail: detail));
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.getWeatherDetail(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget(const WeatherDetailPage(
      name: 'Tokyo',
      latitude: 35.6895,
      longitude: 139.6917,
    )));

    await tester.pump();

    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('28.5°C'), findsOneWidget);
    expect(find.text('Cloud'), findsOneWidget); // weatherCode 1 = Cloud
    expect(find.textContaining('Updated At null:null'),
        findsOneWidget); // Invalid date
  });

  testWidgets('displays Unknown emoji and condition for unknown weatherCode',
      (WidgetTester tester) async {
    final detail = WeatherDetail(
      currentWeather: CurrentWeather(
        time: "2025-07-04T15:00",
        temperature: 29.0,
        weatherCode: 999, // unknown case
      ),
    );

    when(() => mockCubit.state)
        .thenReturn(WeatherDetailSuccess(detail: detail));
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.getWeatherDetail(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestWidget(const WeatherDetailPage(
      name: 'London',
      latitude: 51.5074,
      longitude: -0.1278,
    )));

    await tester.pump();

    expect(find.text('London'), findsOneWidget);
    expect(find.text('29.0°C'), findsOneWidget);
    expect(find.text('Unknown'), findsNWidgets(2)); // both condition and emoji
  });
}
