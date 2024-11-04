import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/closet_data.dart';

class ClosetViewModel extends ChangeNotifier {
  List<ClosetData> closetItems = [];

  Future<void> fetchClosetData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/classify')); // API URL로 변경하세요.

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      closetItems = [
        ClosetData.fromJson(jsonResponse),
      ];
      notifyListeners();  // 데이터가 변경되었음을 알림
    } else {
      throw Exception('Failed to load closet data');
    }
  }
}
