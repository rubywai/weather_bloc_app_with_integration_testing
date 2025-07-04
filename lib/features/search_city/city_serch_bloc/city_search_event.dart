sealed class CitySearchEvent {}

class CitySearchRequestedEvent extends CitySearchEvent {
  final String city;
  CitySearchRequestedEvent(this.city);
}
