import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // 백엔드 연동 위한 의존성
import 'dart:convert';
import 'signup_page.dart';
import 'package:workout/widget/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/users/login'), // 백엔드 로그인 API 포인트
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': _username,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        // 사용자 이름을 SharedPreferences에 저장
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUsername', _username);

        // 로그인 성공 시 username을 Navigation 위젯으로 전달 (Navigation에서 타 페이지로 전달)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Navigation(username: _username), // 사용자 정보 전달
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('아이디 혹은 비밀번호가 일치하지 않습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인에 실패했습니다. 잠시 후 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      // 네트워크 오류나 요청 실패 등
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와의 통신 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검은색으로 설정
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/fitnessIcon.png', // 로그인 화면 아이콘 이미지
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              // 어플 이름 추가
              Text(
                'PlanFit',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60),
              // 아이디 입력란
              TextFormField(
                style: TextStyle(color: Colors.white), // 텍스트 입력 시 색상 설정
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850], // 텍스트 필드 배경색을 어두운 회색으로 설정
                  labelText: '아이디',
                  labelStyle: TextStyle(color: Colors.white54), // 라벨 색상 설정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal), // 테두리 색상 설정
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white54),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 25),
              // 비밀번호 입력란
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  labelText: '비밀번호',
                  labelStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white54),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 30),
              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _login();
                  }
                },
                child: Text('로그인', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // 버튼 배경색 설정
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // 회원가입 버튼
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupPage()), // 회원가입 페이지로 이동
                  );
                },
                child: Text(
                  "회원가입",
                  style: TextStyle(color: Colors.tealAccent), // 텍스트 버튼 색상 설정
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
