import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImgInfoViewModel extends ChangeNotifier {
  String _classification = "";
  String _patternCategory = "";
  String _category = "";
  String _colorPalette = "";
  String _colorName = "";
// Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에 선택된 옵션 저장
  Future<void> saveSelectedOptions() async {
    try {
      // Firestore에 저장할 데이터 구성
      Map<String, dynamic> data = {
        'style': selectedOptions.style,
        'category': selectedOptions.category,
        'class': selectedOptions.classname,
        'color': selectedOptions.color,
        'season': selectedOptions.season,
        'pattern': selectedOptions.pattern,
      };

      // Firestore의 컬렉션에 데이터 추가
      await _firestore.collection('item').add(data);

      print("데이터가 성공적으로 Firestore에 저장되었습니다.");
    } catch (e) {
      print("데이터 저장 중 오류 발생: $e");
    }
  }
  // 선택된 옵션을 저장하는 클래스
  SelectedOptions _selectedOptions = SelectedOptions(
    style: '기본',
    category: '상의',
    classname: '셔츠',
    color: 'Black',
    season: '봄',
    pattern: 'Solid',
  );

  String get classification => _classification;
  String get patternCategory => _patternCategory;
  String get category => _category;
  String get colorPalette => _colorPalette;
  String get colorName => _colorName;

  SelectedOptions get selectedOptions => _selectedOptions;

  Future<void> uploadImage(BuildContext context, File image) async {
    if (image == null) return;

    final url = Uri.parse("http://10.0.2.2:8000/classify");
    final request = http.MultipartRequest("POST", url)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("서버 응답: $responseBody");

      // JSON 데이터를 Map으로 변환
      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      // 데이터 설정
      _classification = jsonResponse['classification'][1]['class'];
      _patternCategory = jsonResponse['classification'][0]['pattern_category'];
      _category = jsonResponse['classification'][1]['category'];
      _colorPalette = jsonResponse['classification'][1]['color_palette'];
      _colorName = jsonResponse['classification'][1]['color_name'];

      // 초기값 설정 메서드 호출
      setSelectedOptions();

      notifyListeners(); // 데이터가 변경되었음을 알림
    } else {
      print("이미지 업로드 실패: ${response.statusCode}");
    }
  }

  // 선택된 옵션을 API 응답에 따라 설정하는 메서드
  void setSelectedOptions() {
    _selectedOptions = SelectedOptions(
      style: '기본', // 예시: 분류를 스타일로 사용
      category: _category,
      classname:_classification,
      color: _colorName,
      season: '봄', // 기본값 또는 API 응답에 따라 변경
      pattern: _patternCategory,
    );
    notifyListeners();
  }

  // 옵션 업데이트 메서드
  void updateOption(String optionName, String value) {
    switch (optionName) {
      case '스타일':
        _selectedOptions.style = value;
        break;
      case '카테고리':
        _selectedOptions.category = value;
        break;
      case '클래스':
        _selectedOptions.classname = value;
        break;
      case '색상':
        _selectedOptions.color = value;
        break;
      case '계절':
        _selectedOptions.season = value;
        break;
      case '패턴':
        _selectedOptions.pattern = value;
        break;
    }
    notifyListeners(); // 변경된 사항 알림
  }
}

// 선택된 옵션 클래스를 추가
class SelectedOptions {
  String style;
  String category;
  String color;
  String season;
  String pattern;
  String classname;

  SelectedOptions({
    required this.style,
    required this.category,
    required this.color,
    required this.season,
    required this.pattern,
    required this.classname,
  });
}
