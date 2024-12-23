import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutService {
  static const String _baseUrl = 'http://localhost:8080/api/workouts';

  // 모든 운동 정보 조회 메서드
  Future<List<Map<String, dynamic>>> getAllWorkouts() async {
    final url = Uri.parse('$_baseUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> workouts = json.decode(response.body);
      return workouts.map((workout) => {
        'workoutName': workout['workoutName'],
        'guide': workout['guide'],
        'bodyPart': workout['bodyPart'],
        'workoutImage': workout['workoutImage'], // 이미지 데이터 가져오기 (Base64 등으로 변환 가능)
      }).toList();
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  // 운동 추가 메서드
  Future<String> addWorkout({
    required String workoutName,
    required String guide,
    required String bodyPart,
    required http.MultipartFile workoutImage
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/add'));
    request.fields['workoutName'] = workoutName;
    request.fields['guide'] = guide;
    request.fields['bodyPart'] = bodyPart;
    request.files.add(workoutImage);

    var response = await request.send();
    if (response.statusCode == 200) {
      return 'Workout added successfully!';
    } else {
      return 'Failed to add workout';
    }
  }
}
