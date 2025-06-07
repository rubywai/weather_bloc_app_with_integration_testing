import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/models/city_search_model.dart';
import '../data/services/city_search_service.dart';
import 'city_search_state.dart';

class CitySearchCubit extends Cubit<CitySearchState> {
  CitySearchCubit() : super(CitySearchFormSate());
  final CitySearchService _service = GetIt.I.get();
  void search(String name) async {
    try {
      emit(CitySearchLoading());
      CityModel cityModel = await _service.searchCity(name: name, count: 15);
      emit(CitySearchSuccess(cityModel: cityModel));
    } catch (e) {
      print("api error $e");
      emit(CitySearchFailed(errorMessage: "Failed to Load"));
    }
  }
}
