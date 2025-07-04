import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_bloc.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_event.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_state.dart';
import 'package:weather_bloc_app/features/search_city/data/models/city_search_model.dart';
import 'package:weather_bloc_app/features/search_city/data/services/city_search_service.dart';

class MockCitySearchService extends Mock implements CitySearchService {}

void main() {
  late MockCitySearchService mockService;
  late CityModel mockModel;

  setUp(() {
    mockService = MockCitySearchService();
    mockModel =
        CityModel(results: []); // Adjust if CityModel has required fields
    GetIt.I.registerSingleton<CitySearchService>(mockService);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('CitySearchBloc', () {
    blocTest<CitySearchBloc, CitySearchState>(
      'emits [CitySearchLoading, CitySearchSuccess] when search is successful',
      build: () {
        when(() => mockService.searchCity(
            name: any(named: 'name'),
            count: any(named: 'count'))).thenAnswer((_) async => mockModel);
        return CitySearchBloc();
      },
      act: (bloc) => bloc.add(CitySearchRequestedEvent('Singapore')),
      wait: const Duration(milliseconds: 600), // due to debounce
      expect: () => [
        isA<CitySearchLoading>(),
        isA<CitySearchSuccess>()
            .having((s) => s.cityModel, 'cityModel', mockModel),
      ],
      verify: (_) {
        verify(() => mockService.searchCity(name: 'Singapore', count: 15))
            .called(1);
      },
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'emits [CitySearchLoading, CitySearchFailed] when service throws error',
      build: () {
        when(() => mockService.searchCity(
            name: any(named: 'name'),
            count: any(named: 'count'))).thenThrow(Exception('error'));
        return CitySearchBloc();
      },
      act: (bloc) => bloc.add(CitySearchRequestedEvent('Unknown')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<CitySearchLoading>(),
        isA<CitySearchFailed>()
            .having((f) => f.errorMessage, 'errorMessage', 'Failed to load'),
      ],
    );
  });
}
