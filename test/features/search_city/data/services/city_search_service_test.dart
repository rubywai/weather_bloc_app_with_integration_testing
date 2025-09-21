import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:weather_bloc_app/features/search_city/data/services/city_search_service.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockDio mockDio;
  late CitySearchService service;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    service = CitySearchService(mockDio);
  });

  group('api service test', () {
    test('should construct CitySearchService', () {
      final dio = Dio();
      final instance = CitySearchService(dio);
      expect(instance, isA<CitySearchService>());
    });

    test('searchCity should return parsed CityModel', () async {
      final responseJson = {
        "results": [
          {
            "id": 1,
            "name": "Singapore",
            "latitude": 1.3521,
            "longitude": 103.8198,
            "country": "SG"
          }
        ]
      };

      final response = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: ''),
        data: responseJson,
        statusCode: 200,
      );

      when(() => mockDio.fetch<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => response);

      final result = await service.searchCity(name: "Singapore", count: 10);

      final jsonList = result.results!.map((e) => e.toJson()).toList();
      expect(jsonList, equals(responseJson['results']));
    });
  });
}
