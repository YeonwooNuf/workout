import 'dart:convert';
import 'package:http/http.dart' as http;

// 서버와 통신하기 위한 PlanService 클래스
class PlanService {
  // 백엔드 서버 URL 대입 (플랜 관련 엔드포인트)
  static const String _baseUrl = 'http://10.0.2.2:8080/api/plans';

  // 모든 플랜 정보 조회 메서드
  Future<List<Map<String, dynamic>>> getAllPlans() async {
    final url = Uri.parse('$_baseUrl'); // 모든 플랜 조회 엔드포인트
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> plans = json.decode(response.body);
      return plans.map((plan) => {
        'planId': plan['planId'], // 플랜 구분을 위한 planId(기본키)
        'planName': plan['planName'],
        'workoutDays': plan['workoutDays'],
        'planStatus': plan['planStatus'], // 선택 상태 정보 포함
      }).toList();
    } else {
      print('Failed to load plans: ${response.statusCode}');
      return [];
    }
  }

  // 사용자별 선택된 플랜 조회 메서드
  Future<Map<String, dynamic>?> getSelectedPlan(String username) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/user-plans/$username'); // 사용자별 선택된 플랜 조회
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load selected plan: ${response.statusCode}');
      return null;
    }
  }

  // 플랜 선택 및 저장 메서드
  Future<String> selectPlan(String username, int planId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/user-plans/$username/select?planId=$planId');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      return 'Plan selected successfully!';
    } else {
      return 'Failed to select plan: ${response.body}';
    }
  }
}
