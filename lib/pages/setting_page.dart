import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/login/login_page.dart';
import 'package:workout/pages/workout_list_page.dart';
import 'package:workout/service/sv_users.dart';
import 'package:workout/pages/add_workout_page.dart'; // AddWorkoutPage import

class SettingsPage extends StatelessWidget {
  final String username;
  final UserService userService = UserService();

  SettingsPage({required this.username});

  // 로그아웃 메소드
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUsername');

    // 기존의 모든 화면을 제거하고 로그인 페이지로 이동
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  // sv_users의 탈퇴 메소드 호출
  Future<void> _deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원 탈퇴하기'),
          content: Text('정말로 탈퇴하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('예'),
              onPressed: () async {
                final result = await userService.deleteAccount(username);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );

                if (result == 'Account deleted successfully!') {
                  await _logout(context); // 계정 삭제 후 로그아웃
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  Navigator.of(context).pop(); // 삭제 실패 시 다이얼로그 닫기
                }
              },
            ),
            TextButton(
              child: Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '계정 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('사용자 아이디'),
              subtitle: Text(username),
            ),
            Divider(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _deleteAccount(context),
              child: Text('계정 탈퇴'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWorkoutPage()),
                );
              },
              child: Text('운동 추가하기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WorkoutListPage()), // WorkoutListPage로 이동
                );
              },
              child: Text('운동 목록 보기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
