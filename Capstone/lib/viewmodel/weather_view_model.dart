import 'package:flutter/material.dart';
import '../service/api_service.dart'; // ApiService 임포트
import '../model/weather_data.dart';

class WeatherViewModel extends ChangeNotifier {
  List<WeatherData> weatherData = [];
  bool dataState = false;
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  WeatherViewModel() {
    getData();
  }

  getData() async {
    try {
      weatherData = await _apiService.fetchWeatherData();
      dataState = true;
      notifyListeners(); // 데이터가 변경되었음을 알림
    } catch (e) {
      print('Error: $e'); // 에러 핸들링
      dataState = false;
      notifyListeners();
    }
  }
}
