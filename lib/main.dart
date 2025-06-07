import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_bloc.dart';
import 'package:weather_bloc_app/features/weather_detail/weather_detail_bloc/weather_detail_cubit.dart';
import 'package:weather_bloc_app/locator/locator.dart';

import 'features/search_city/ui/search_city_page.dart';

void main() async {
  await setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CitySearchCubit>(
          create: (context) => CitySearchCubit(),
          child: Container(),
        ),
        BlocProvider<WeatherDetailCubit>(
          create: (context) => WeatherDetailCubit(),
          child: Container(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SearchCityPage(),
      ),
    );
  }
}
