import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
      ),
      body: Center(
        child: Text('커뮤니티 페이지', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
