import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:weather_bloc_app/features/weather_detail/data/models/weather_detail_model.dart';

import '../../../../common/url_const.dart';
part 'weather_detail_service.g.dart';

@RestApi(baseUrl: UrlConst.weatherDetailBaseUrl)
abstract class WeatherDetailService {
  factory WeatherDetailService(Dio dio) => _WeatherDetailService(dio);
  @GET(UrlConst.forecast)
  Future<WeatherDetail> getWeatherDetail({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('current_weather') required bool currentWeather,
  });
}
