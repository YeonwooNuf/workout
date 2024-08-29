import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  late TabController _tabController;
  List<DateTime> daysInMonth = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateDaysInMonth();
  }

  void _generateDaysInMonth() {
    daysInMonth.clear();
    DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonthCount = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int firstDayOfWeek = firstDayOfMonth.weekday;

    // 공백 맞추려면 firstDayOfWeek에서 더하거나 빼면됨
    for (int i = 0; i < firstDayOfWeek; i++) {
      daysInMonth.add(DateTime(0));
    }

    for (int i = 0; i < daysInMonthCount; i++) {
      daysInMonth.add(DateTime(selectedDate.year, selectedDate.month, i + 1));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1C1E),
        title: Text('프로필', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // 설정 버튼 클릭 시 동작 추가
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: '기록'),
            Tab(text: '활동'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecordTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }

  Widget _buildRecordTab() {
    return Column(
      children: [
        _buildDateNavigation(),
        _buildWeekdayHeaders(),
        Expanded(
          child: _buildCustomCalendar(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // 운동 기록 추가하는 동작 추가
            },
            child: Text('운동 기록 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTab() {
    return Center(
      child: Text('활동 탭 내용', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildDateNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
                _generateDaysInMonth();
              });
            },
          ),
          Text(
            '${selectedDate.year}년 ${selectedDate.month.toString().padLeft(2, '0')}월',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
                _generateDaysInMonth();
              });
            },
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedDate = DateTime.now();
                _generateDaysInMonth();
              });
            },
            style: TextButton.styleFrom(
              
              side: BorderSide(color: Colors.white), // 테두리 색상 설정
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              foregroundColor: Colors.white, // 글자 색상 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 테두리의 각진 정도 설정
              ),
            ),
            
            child: Text('오늘'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomCalendar() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        if (daysInMonth[index].year == 0) {
          return Container();
        }
        bool isSelected = daysInMonth[index].day == selectedDate.day &&
            daysInMonth[index].month == selectedDate.month &&
            daysInMonth[index].year == selectedDate.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = daysInMonth[index];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              '${daysInMonth[index].day}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
