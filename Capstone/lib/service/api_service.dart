// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_data.dart';

class ApiService {
  final String serviceKey = '%2FAWFYHmCe1YGFJbVpskX6WgKpkjvs3joL8rTZ24kja%2BfII%2FMX%2BvPbsTHx%2B8G7GHek5nHx8cRwusgBPpd0yaLKg%3D%3D'; // 실제 서비스 키로 변경하세요.

  // 오늘 날짜를 YYYYMMDD 형식으로 반환하는 메서드
  String getToday() {
    final DateTime now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'; // YYYYMMDD 형식
  }

  Future<List<WeatherData>> fetchWeatherData() async {
    final String date = getToday(); // 오늘 날짜를 가져옴
    final apiurl = 'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$serviceKey&pageNo=1&numOfRows=1000&dataType=JSON&base_date=$date&base_time=0200&nx=55&ny=127';
    final response = await http.get(
      Uri.parse(apiurl
      ),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final items = result['response']['body']['items']['item'];
// 필요한 인덱스에서 데이터 추출
      List<WeatherData> weatherDataList = [];

      weatherDataList.add(WeatherData.fromJson({
        'sky': items[5]['fcstValue'],
        'tmx': items[157]['fcstValue'],
        'tmn': items[48]['fcstValue'],
        'pty': items[6]['fcstValue'],
      }));

      weatherDataList.add(WeatherData.fromJson({
        'sky': items[295]['fcstValue'],
        'tmx': items[447]['fcstValue'],
        'tmn': items[338]['fcstValue'],
        'pty': items[296]['fcstValue'],
      }));

      weatherDataList.add(WeatherData.fromJson({
        'sky': items[585]['fcstValue'],
        'tmx': items[737]['fcstValue'],
        'tmn': items[628]['fcstValue'],
        'pty': items[586]['fcstValue'],
      }));

      return weatherDataList; // 필터링된 데이터 리스트 반환
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
