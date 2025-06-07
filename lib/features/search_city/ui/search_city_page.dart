import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_bloc.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_state.dart';
import 'package:weather_bloc_app/features/search_city/data/models/city_search_model.dart';
import 'package:weather_bloc_app/features/weather_detail/ui/weather_detail_page.dart';

class SearchCityPage extends StatefulWidget {
  const SearchCityPage({super.key});

  @override
  State<SearchCityPage> createState() => _SearchCityPageState();
}

class _SearchCityPageState extends State<SearchCityPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Bloc App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search City',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchCity();
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<CitySearchCubit, CitySearchState>(
                builder: (context, state) {
                  return switch (state) {
                    CitySearchLoading() => Center(
                        child: CircularProgressIndicator(),
                      ),
                    CitySearchFormSate() => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 40,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Search City")
                          ],
                        ),
                      ),
                    CitySearchSuccess(cityModel: CityModel model) =>
                      _cityList(model),
                    CitySearchFailed() => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Something wrong"),
                            SizedBox(
                              height: 16,
                            ),
                            TextButton(
                              onPressed: () {
                                _searchCity();
                              },
                              child: Text("Try Again"),
                            ),
                          ],
                        ),
                      ),
                  };
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cityList(CityModel model) {
    List<CitySearchModel> cities = model.results ?? [];
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        CitySearchModel citySearchModel = cities[index];
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WeatherDetailPage(
                    name: citySearchModel.name,
                    latitude: citySearchModel.latitude,
                    longitude: citySearchModel.longitude,
                  ),
                ),
              );
            },
            title: Text(
              citySearchModel.name,
            ),
            subtitle: Text(citySearchModel.country),
          ),
        );
      },
    );
  }

  void _searchCity() {
    String city = _searchController.text.trim();
    if (city.isNotEmpty) {
      BlocProvider.of<CitySearchCubit>(context).search(city);
    }
  }
}
