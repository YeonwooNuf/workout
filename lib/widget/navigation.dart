import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/main_page.dart';
import '../pages/analysis_page.dart';
import '../pages/community_page.dart';
import '../pages/profile_page.dart';

class Navigation extends StatefulWidget {
  final String username;

  Navigation({required this.username});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  int? userId; // ✅ userId 변수 추가

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('loggedInUserId'); // ✅ userId 가져오기
      _pages = [
        MainPage(selectedPlan: {'plan': '기본 플랜'}, username: widget.username),
        AnalysisPage(),
        CommunityPage(),
        if (userId != null)
          ProfilePage(userId: userId!, username: widget.username) // ✅ userId 전달
        else
          Center(child: CircularProgressIndicator()), // ✅ userId가 없으면 로딩 표시
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userId == null
          ? Center(child: CircularProgressIndicator()) // ✅ userId가 없으면 로딩 표시
          : _pages[_selectedIndex], // ✅ 페이지 표시
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
