import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
class RandomItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 랜덤 아이템 가져오기
  Future<Map<String, dynamic>?> getRandomItem() async {
    try {
      // 'items' 컬렉션에서 모든 문서를 가져오기
      QuerySnapshot snapshot = await _firestore.collection('item').get();

      // 문서가 비어 있는 경우 처리
      if (snapshot.docs.isEmpty) {
        print("아이템이 없습니다.");
        return null;
      }

      // 랜덤 인덱스로 아이템 선택
      var randomIndex = Random().nextInt(snapshot.docs.length);  // 랜덤 인덱스 (50% 확률로)
      var randomItem = snapshot.docs[randomIndex].data() as Map<String, dynamic>;
      print(randomItem);
      return randomItem;  // 선택된 랜덤 아이템 반환
    } catch (e) {
      print('Firestore에서 랜덤 아이템 가져오기 오류: $e');
      return null;  // 오류 발생 시 null 반환
    }
  }

  // 추천 API로 아이템을 보내고 응답 받기 (GET 방식으로 변경)
  Future<Map<String, dynamic>> sendItemToRecommendAPI(Map<String, dynamic> item,String selectedStyle,String setSeason) async {
    if (item == null || item.isEmpty) {
      print('전송할 아이템 정보가 없습니다.');
      return {};  // null 또는 빈 데이터일 경우 빈 데이터 반환
    }

    try {
      // 추천 API 엔드포인트 URL
      final url = Uri.parse('http://10.0.2.2:8000/recommend'); // 실제 URL로 변경 필요

      // 요청 데이터 (아이템의 특정 속성들)
      final queryParams = {
        'setSeason':setSeason,
        'selectedStyle': selectedStyle,
        'season': item['season'],
        'style': item['style'],
        'category': item['category'],
        'pattern': item['pattern'],
        'color': item['color'],
      };

      // URL에 쿼리 파라미터 추가
      final uri = url.replace(queryParameters: queryParams);

      // GET 요청 보내기
      final response = await http.get(uri);

      // 응답 처리
      if (response.statusCode == 200) {
        // 서버에서 받은 응답 데이터
        final responseData = json.decode(response.body);
        return responseData;  // 예: {"recommended_color": "blue", "recommended_pattern": "stripe"}
      } else {
        throw Exception('추천 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 오류: $e');
      return {};  // 오류 발생 시 빈 데이터 반환
    }
  }
}
