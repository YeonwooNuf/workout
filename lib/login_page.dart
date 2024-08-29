// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'signup_page.dart';  // 회원가입 페이지 import
// import 'navigation.dart';  // 메인 페이지 import

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _username = '';
//   String _password = '';

//   Future<void> _login() async {
//     final response = await http.post(
//       Uri.parse('http://localhost:8080/allUsers'), // 로그인 API 엔드포인트
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(<String, String>{
//         'username': _username,
//         'password': _password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => Navigation()), // 메인 페이지로 이동
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid username or password')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("로그인"),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 decoration: InputDecoration(labelText: '아이디'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '아이디를 입력해주세요';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _username = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: '비밀번호'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '비밀번호를 입력해주세요';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _password = value!,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     _login();
//                   }
//                 },
//                 child: Text('로그인'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => SignupPage()), // 회원가입 페이지로 이동
//                   );
//                 },
//                 child: Text("회원가입"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
