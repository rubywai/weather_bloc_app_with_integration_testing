import 'package:json_annotation/json_annotation.dart';
part 'city_search_model.g.dart';

@JsonSerializable()
class CityModel {
  final List<CitySearchModel>? results;

  CityModel({required this.results});
  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

@JsonSerializable()
class CitySearchModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  CitySearchModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory CitySearchModel.fromJson(Map<String, dynamic> json) =>
      _$CitySearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$CitySearchModelToJson(this);
}
