import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_bloc_app/features/search_city/data/services/city_search_service.dart';
import 'package:weather_bloc_app/features/weather_detail/data/service/weather_detail_service.dart';

Future<void> setUpLocator() async {
  GetIt getIt = GetIt.I;
  Dio dio = Dio();
  getIt.registerSingleton(CitySearchService(dio));
  getIt.registerSingleton(WeatherDetailService(dio));
}
