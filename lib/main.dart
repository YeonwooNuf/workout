import 'package:flutter/material.dart';
import 'main_page.dart';
import 'navigation.dart';

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
      home: Navigation(),
    );
  }
}
