import 'package:clima/services/networking.dart';
import 'location.dart';

const String apiKey = 'PEuiMfgLysa3iCa0gXOb9mu7VlPcMYydw8Lp7UMXswM';
double latitude;
double longitude;



class GetWeatherData{

  Future<dynamic> getCityWeather(String city) async{

    NetworkHelper networkHelper = NetworkHelper(url: 'https://weather.ls.hereapi.com/weather/1.0/report.json?apiKey=$apiKey&product=observation&name=$city');
    var weatherdata = await networkHelper.getData();
    return weatherdata;

  }

  Future getWeather() async{
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.getLatitude();
    longitude = location.getLongitude();
    NetworkHelper networkHelper = NetworkHelper(url: 'https://weather.ls.hereapi.com/weather/1.0/report.json?apiKey=$apiKey&product=observation&latitude=$latitude&longitude=$longitude&oneobservation=true');
    var weatherdata = await networkHelper.getData();
    return weatherdata;

  }
}

class WeatherModel {
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
