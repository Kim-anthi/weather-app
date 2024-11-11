import 'package:api_weather_app/models/weather_model.dart';
import 'package:api_weather_app/service/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('bd1216975ce3dc110b556acfbcf25f5b');
  Weather? _weather;


  //fetch weather
  _fetchWeather() async{
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city
    try{
      final wetaher = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = wetaher;
      });
    }
    //any errors
    catch (e){
      print(e);
    }
  }
  //weather animations
  String getWeatherAnimation(String ? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'fog':
      case 'mist':
      case 'smoke':
        return 'assets/chilly.json';
      case 'haze':
      case 'dust':
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'Thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }

  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city...",
              style: const TextStyle(
                  fontSize: 30
              ),
            ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature name
            Text('${_weather?.temperature.round()}°C',
              style: const TextStyle(
                  fontSize: 30
              ),
            ),

            //weather condition
            Text(_weather?.mainCondition ?? "",
              style: const TextStyle(
                fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }
}
