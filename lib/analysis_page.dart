import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분석'),
      ),
      body: Center(
        child: Text('분석 페이지', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
