import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/weather_detail_model.dart';
import '../weather_detail_bloc/weather_detail_cubit.dart';
import '../weather_detail_bloc/weather_detail_state.dart';

class WeatherDetailPage extends StatefulWidget {
  const WeatherDetailPage({
    super.key,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
  final String name;
  final double latitude;
  final double longitude;

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWeatherDetail();
    });
  }

  void _getWeatherDetail() {
    BlocProvider.of<WeatherDetailCubit>(context).getWeatherDetail(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff283593),
        foregroundColor: Colors.white,
        title: Text("Weather Detail"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff283593),
              Color(0xff3949AB),
              Color(0xff5C6BC0),
            ],
          ),
        ),
        child: BlocBuilder<WeatherDetailCubit, WeatherDetailState>(
          builder: (context, state) {
            return switch (state) {
              WeatherDetailLoading() => Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              WeatherDetailSuccess(detail: WeatherDetail detail) =>
                _currentWeather(detail),
              WeatherDetailFailed() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Something wrong"),
                      SizedBox(
                        height: 16,
                      ),
                      TextButton(
                        onPressed: () {
                          _getWeatherDetail();
                        },
                        child: Text("Try Again"),
                      ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _currentWeather(WeatherDetail detail) {
    CurrentWeather currentWeather = detail.currentWeather;
    DateTime? dateTime = DateTime.tryParse(currentWeather.time);
    String updatedAt = 'Updated At ${dateTime?.hour}:${dateTime?.minute}';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            updatedAt,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentWeather.weatherCode.toCondition().toEmoji(),
                style: TextStyle(fontSize: 52),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                '${currentWeather.temperature.toString()}°C',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            currentWeather.weatherCode.toCondition(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          )
        ],
      ),
    );
  }
}

extension on int {
  String toCondition() {
    switch (this) {
      case 0:
        return 'Clear';
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return 'Cloud';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'Snowy';
      default:
        return 'Unknown';
    }
  }
}

extension on String {
  String toEmoji() {
    switch (this) {
      case "Clear":
        return '☀️';
      case "Rainy":
        return '🌧️';
      case 'Cloud':
        return '☁️';
      case 'Snowy':
        return '🌨️';
      default:
        return 'Unknown';
    }
  }
}
