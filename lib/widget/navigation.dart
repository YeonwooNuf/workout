import 'package:flutter/material.dart';
import '../pages/main_page.dart';
import '../pages/analysis_page.dart';
import '../pages/community_page.dart';
import '../pages/profile_page.dart';

class Navigation extends StatefulWidget {
  final String username; // 사용자 이름을 전달받음

  Navigation({required this.username});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // 각 페이지를 리스트로 저장
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 초기화할 때 username을 MainPage에 전달
    _pages = [
      MainPage(selectedPlan: {'plan': '기본 플랜'}, username: widget.username),
      AnalysisPage(),
      CommunityPage(),
      ProfilePage(username: widget.username),
    ];
  }

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