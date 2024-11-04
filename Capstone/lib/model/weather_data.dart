// models/weather_data.dart

class WeatherData {
  final String sky;
  final String tmx;
  final String tmn;
  final String pty;

  WeatherData({required this.sky, required this.tmx, required this.tmn, required this.pty});

  // JSON 데이터를 WeatherData 객체로 변환하는 함수
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      sky: json['sky'],
      tmx: json['tmx'],
      tmn: json['tmn'],
      pty: json['pty'],
    );
  }
}
