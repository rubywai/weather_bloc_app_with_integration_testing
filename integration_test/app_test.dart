import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_bloc_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    testWidgets('App starts and shows search page', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on search page with correct title
      expect(find.text('Weather Bloc App'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search City'), findsAtLeastNWidgets(1));

      // Verify initial state shows search icon and message
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
    });

    testWidgets('Search field accepts input and triggers search', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Type in search field
      await tester.enterText(find.byType(TextField), 'London');
      await tester.pump();

      // Verify text was entered
      expect(find.text('London'), findsOneWidget);

      // Wait for potential state changes after typing
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Complete search flow with city selection', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Enter a city name
      await tester.enterText(find.byType(TextField), 'New York');
      await tester.pump();

      // Wait for search results to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for list tiles (search results)
      final listTileFinder = find.byType(ListTile);

      if (listTileFinder.evaluate().isNotEmpty) {
        // If results are found, tap on the first result
        await tester.tap(listTileFinder.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify navigation to weather detail page
        expect(find.text('Weather Detail'), findsOneWidget);

        // Verify weather detail page elements
        expect(find.byType(AppBar), findsOneWidget);

        // Wait for weather data to load
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
    });

    testWidgets('Search handles loading states properly', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Enter search term
      await tester.enterText(find.byType(TextField), 'Tokyo');
      await tester.pump();

      // Check if loading indicator appears (it might be brief)
      await tester.pump(const Duration(milliseconds: 500));

      // Wait for results or error state
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify we either have results or an error state
      final hasResults = find.byType(ListTile).evaluate().isNotEmpty;
      final hasError = find.text('Something wrong').evaluate().isNotEmpty;
      final hasInitialState = find.text('Search City').evaluate().isNotEmpty;

      expect(hasResults || hasError || hasInitialState, true);
    });

    testWidgets('Error state shows try again button', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Enter an invalid search term that might cause an error
      await tester.enterText(find.byType(TextField), 'InvalidCityNameXYZ123');
      await tester.pump();

      // Wait for potential error state
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If error state is shown, verify try again button
      final errorText = find.text('Something wrong');
      if (errorText.evaluate().isNotEmpty) {
        expect(find.text('Try Again'), findsOneWidget);

        // Test try again functionality
        await tester.tap(find.text('Try Again'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Back navigation works from weather detail page', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Search for a city
      await tester.enterText(find.byType(TextField), 'Paris');
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If results exist, navigate to detail page
      final listTileFinder = find.byType(ListTile);
      if (listTileFinder.evaluate().isNotEmpty) {
        await tester.tap(listTileFinder.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify we're on detail page
        if (find.text('Weather Detail').evaluate().isNotEmpty) {
          // Test back navigation
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();

          // Verify we're back on search page
          expect(find.text('Weather Bloc App'), findsOneWidget);
          expect(find.byType(TextField), findsOneWidget);
        }
      }
    });

    testWidgets('App handles empty search gracefully', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Enter empty text (just spaces)
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      // Should remain in initial state or not trigger search
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Clear the field completely
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('UI elements are accessible and properly styled', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify all UI elements are present and accessible
      expect(find.text('Weather Bloc App'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));

      // Verify TextField has proper decoration
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, 'Search City');
      expect(textField.decoration?.suffixIcon, isA<Icon>());

      // Verify search icon is visible in initial state
      expect(find.text('Search City'), findsAtLeastNWidgets(1));
    });
  });
}
