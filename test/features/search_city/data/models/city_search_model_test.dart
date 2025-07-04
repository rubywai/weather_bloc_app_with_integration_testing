import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bloc_app/features/search_city/data/models/city_search_model.dart';

void main() {
  group('CitySearchModel', () {
    test('fromJson and toJson', () {
      final json = {
        "id": 1,
        "name": "Singapore",
        "latitude": 1.3521,
        "longitude": 103.8198,
        "country": "SG"
      };

      final model = CitySearchModel.fromJson(json);
      expect(model.toJson(), equals(json));
    });
  });

  group('CityModel', () {
    test('fromJson and toJson should convert between JSON and model properly',
        () {
      final inputJson = {
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

      final model = CityModel.fromJson(inputJson);
      expect(model.results, isNotNull);
      expect(model.results!.first.name, "Singapore");

      // ✅ FIX: Manually map toJson of each item
      final results = model.results!.map((e) => e.toJson()).toList();
      expect(results, equals(inputJson['results']));
    });
  });
}
