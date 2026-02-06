// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bloc_app/locator/locator.dart';
import 'package:weather_bloc_app/main.dart';

void main() {
  testWidgets('App initializes without crashing', (WidgetTester tester) async {
    // Set up the service locator before building the app
    await setUpLocator();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);

    // Clean up the service locator after the test
    // (Note: You might want to add a cleanup method to your locator)
  });
}
