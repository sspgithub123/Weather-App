class Weather{
  String? cityName;
  double? temp;
  double? wind;
  int? humidity;
  double? feels_like;
  int? pressure;
  Weather(
    {
      this.cityName,
      this.temp,
      this.wind,
      this.humidity,
      this.feels_like,      
      this.pressure,      
    }
  );

  Weather.fromJson(Map<String, dynamic> json) {
    cityName = json["name"];
    temp = json["main"]["temp"];
    wind = json["main"]["speed"];
    pressure = json["main"]["pressure"];
    humidity = json["main"]["humidity"];
    feels_like = json["main"]["feels_like"];
  }
}

  class Conditions {
  final double temp;
  final double feelslike;

  const Conditions(this.temp, this.feelslike);

  // factory design pattern
  factory Conditions.fromJson(Map<String, dynamic> json) {
    return Conditions(
      json["temp"] as double,
      json["feelslike"] as double,
    );
  } 
}