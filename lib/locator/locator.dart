import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_bloc_app/features/search_city/data/services/city_search_service.dart';
import 'package:weather_bloc_app/features/weather_detail/data/service/weather_detail_service.dart';
import 'package:collection/collection.dart';

Future<void> setUpLocator() async {
  GetIt getIt = GetIt.I;
  Dio dio = Dio();
  _addSslPinning(dio);
  getIt.registerSingleton(CitySearchService(dio));
  getIt.registerSingleton(WeatherDetailService(dio));
}

void _addSslPinning(Dio dio) async {
  final list = await _loadCertificates([
    "assets/geocoding-api.open-meteo.com.pem",
    "assets/open-meteo.com.pem",
  ]);
  dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
    final SecurityContext context = SecurityContext();
    for (final certBytes in list) {
      context.setTrustedCertificatesBytes(certBytes);
    }
    final HttpClient client = HttpClient(context: context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      for (final trustedCertBytes in list) {
        if (const ListEquality().equals(cert.der, trustedCertBytes)) {
          return true;
        }
      }
      return false;
    };
    return client;
  });
}

Future<List<Uint8List>> _loadCertificates(List<String> certificatePaths) async {
  List<Uint8List> certificateList = [];

  for (String path in certificatePaths) {
    try {
      final certBytes = await rootBundle.load(path);
      certificateList.add(certBytes.buffer.asUint8List());
    } catch (error) {
      throw Exception(
          'Failed to load certificate from path: $path, error: $error');
    }
  }

  return certificateList;
}
