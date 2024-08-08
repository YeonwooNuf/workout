import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
      ),
      body: Center(
        child: Text('프로필 페이지', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
