import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../common/url_const.dart';
import '../models/city_search_model.dart';
part 'city_search_service.g.dart';

@RestApi(baseUrl: UrlConst.searchBaseUrl)
abstract class CitySearchService {
  factory CitySearchService(Dio dio) => _CitySearchService(dio);
  @GET(UrlConst.search)
  Future<CityModel> searchCity({
    @Query('name') required String name,
    @Query('count') required int count,
  });
}
