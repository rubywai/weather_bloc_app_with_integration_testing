import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/models/weather_detail_model.dart';
import '../data/service/weather_detail_service.dart';
import 'weather_detail_state.dart';

class WeatherDetailCubit extends Cubit<WeatherDetailState> {
  WeatherDetailCubit() : super(WeatherDetailLoading());
  final WeatherDetailService _detailService = GetIt.I.get();
  void getWeatherDetail({
    required double latitude,
    required double longitude,
  }) async {
    try {
      emit(WeatherDetailLoading());
      WeatherDetail weatherDetail = await _detailService.getWeatherDetail(
        latitude: latitude,
        longitude: longitude,
        currentWeather: true,
      );
      emit(WeatherDetailSuccess(detail: weatherDetail));
    } catch (e) {
      emit(WeatherDetailFailed(errorMessage: 'Failed to load'));
    }
  }
}
