import 'package:flutter/material.dart';
import 'main_page.dart';
import 'analysis_page.dart';
import 'community_page.dart';
import 'profile_page.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // 각 페이지를 리스트로 저장
  final List<Widget> _pages = [
    MainPage(selectedPlan: {'plan': '기본 플랜'}),
    AnalysisPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 선택된 페이지 표시
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '운동'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '분석'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}
