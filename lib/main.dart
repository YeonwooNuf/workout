import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workout/login/login_page.dart';
import 'pages/main_page.dart';
import 'widget/navigation.dart';
import 'package:workout/login/login_page.dart';

//메인 실행 코드
void main() {
  runApp(WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '운동 기록 어플',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,  // 달력 넣기 위해 지역 설정
      supportedLocales: [
        Locale('en', 'US'), // 영어
        Locale('ko', 'KR'), // 한국어
      ],
      home: LoginPage(),  // 실행 시 로그인 페이지에서 시작
    );
  }
}
