import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../data/models/city_search_model.dart';
import '../data/services/city_search_service.dart';
import 'city_search_event.dart';
import 'city_search_state.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final CitySearchService _service = GetIt.I.get();
  CitySearchBloc() : super(CitySearchFormSate()) {
    on<CitySearchRequestedEvent>(
      _searchCity,
      transformer: (events, mapper) {
        return events
            .debounceTime(
              Duration(milliseconds: 500),
            )
            .switchMap(mapper);
      },
    );
  }
  void _searchCity(
      CitySearchRequestedEvent event, Emitter<CitySearchState> emitter) async {
    try {
      emitter(CitySearchLoading());
      CityModel cityModel =
          await _service.searchCity(name: event.city, count: 15);
      emitter(CitySearchSuccess(cityModel: cityModel));
    } catch (e) {
      emitter(CitySearchFailed(errorMessage: "Failed to load"));
    }
  }
}
