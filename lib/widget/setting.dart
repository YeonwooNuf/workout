import 'package:flutter/material.dart';
import 'package:workout/pages/setting_page.dart';

class SettingsIcon extends StatelessWidget {
  final String username; // 사용자 이름을 받아옴

  const SettingsIcon({required this.username, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(username: username), // 설정 페이지로 이동
          ),
        );
      },
    );
  }
}
