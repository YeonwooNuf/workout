import 'dart:convert';
import 'package:http/http.dart' as http;

// 서버와 통신하기 위한 클래스
class UserService {
  // 백엔드 서버 URL 대입
  static const String _baseUrl = 'http://10.0.2.2:8080/api/users';

  // 사용자 등록 메소드
  Future<String> registerUser({
    required String name,
    required String email,
    required String username,
    required String password,
    required String phoneNumber,
    required String gender,
    required String birthDate,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'birthDate': birthDate,
      }),
    );

    if (response.statusCode == 200) {
      return 'User registered successfully!';
    } else {
      return 'Failed to register user: ${response.body}';
    }
  }

  // 계정 삭제 메서드 추가
  Future<String> deleteAccount(String username) async {
    final url = Uri.parse('$_baseUrl/$username/delete'); // 사용자별 계정 삭제 엔드포인트
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return '회원 탈퇴가 완료되었습니다.';
    } else {
      return 'Failed to delete account: ${response.body}';
    }
  }

  // 사용자 이름으로 사용자 정보 조회 메서드
  Future<Map<String, dynamic>?> getUser(String username) async {
    final url = Uri.parse('$_baseUrl/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load user: ${response.statusCode}');
      return null;
    }
  }

  // 모든 사용자 정보 조회 메서드
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final url = Uri.parse('$_baseUrl/allUsers');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      return users
          .map((user) => {
                'userId': user['userId'], // 사용자 별 구분위한 userId(기본키)
                'name': user['name'],
                'email': user['email'],
                'username': user['username'],
                'phoneNumber': user['phoneNumber'],
                'gender': user['gender'],
                'birthDate': user['birthDate']
              })
          .toList();
    } else {
      print('Failed to load users: ${response.statusCode}');
      return [];
    }
  }
}
