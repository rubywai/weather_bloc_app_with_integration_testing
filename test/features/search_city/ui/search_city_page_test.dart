import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_bloc.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_event.dart';
import 'package:weather_bloc_app/features/search_city/city_serch_bloc/city_search_state.dart';
import 'package:weather_bloc_app/features/search_city/data/models/city_search_model.dart';
import 'package:weather_bloc_app/features/search_city/ui/search_city_page.dart';

class MockCitySearchBloc extends MockBloc<CitySearchEvent, CitySearchState>
    implements CitySearchBloc {}

void main() {
  group('SearchCityPage Tests', () {
    late MockCitySearchBloc mockBloc;

    setUp(() {
      mockBloc = MockCitySearchBloc();
      registerFallbackValue(CitySearchRequestedEvent(''));
    });

    Widget createWidget() {
      return MaterialApp(
        home: BlocProvider<CitySearchBloc>.value(
          value: mockBloc,
          child: const SearchCityPage(),
        ),
      );
    }

    testWidgets('shows app bar and search field', (tester) async {
      when(() => mockBloc.state).thenReturn(CitySearchFormSate());

      await tester.pumpWidget(createWidget());

      expect(find.text('Weather Bloc App'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search City'),
          findsNWidgets(2)); // One in hint, one in center
    });

    testWidgets('shows loading state', (tester) async {
      when(() => mockBloc.state).thenReturn(CitySearchLoading());

      await tester.pumpWidget(createWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(CitySearchFailed(errorMessage: 'Something wrong'));

      await tester.pumpWidget(createWidget());

      expect(find.text('Something wrong'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('triggers search on text input', (tester) async {
      when(() => mockBloc.state).thenReturn(CitySearchFormSate());

      await tester.pumpWidget(createWidget());
      await tester.enterText(find.byType(TextField), 'London');
      await tester.pump(); // Process the text change

      verify(() => mockBloc.add(any(that: isA<CitySearchRequestedEvent>())))
          .called(1);
    });

    testWidgets('shows city list on success', (tester) async {
      final cities = CityModel(results: [
        CitySearchModel(
          id: 1,
          name: 'London',
          country: 'UK',
          latitude: 51.5,
          longitude: -0.1,
        ),
      ]);

      when(() => mockBloc.state)
          .thenReturn(CitySearchSuccess(cityModel: cities));

      await tester.pumpWidget(createWidget());

      expect(find.text('London'), findsOneWidget);
      expect(find.text('UK'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
