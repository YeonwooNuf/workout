import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout/pages/workout_report_page.dart';

class Post {
  final int id;
  final int authorId;
  final String author;
  final String content;
  final String? imageUrl;

  Post({required this.id, required this.authorId, required this.author, required this.content, this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['postId'] ?? 0,
      authorId: json['authorId'] ?? 0,
      author: json['authorUsername'] ?? 'Unknown',
      content: json['content'] ?? 'No content',
      imageUrl: json['postImageUrl'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  final int userId;
  final String username;

  ProfilePage({required this.userId, required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  List<DateTime> daysInMonth = [];
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateDaysInMonth();
    fetchFollowData();
  }

  void _generateDaysInMonth() {
    daysInMonth.clear();
    DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonthCount = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int firstDayOfWeek = firstDayOfMonth.weekday;

    for (int i = 0; i < firstDayOfWeek; i++) {
      daysInMonth.add(DateTime(0));
    }

    for (int i = 0; i < daysInMonthCount; i++) {
      daysInMonth.add(DateTime(selectedDate.year, selectedDate.month, i + 1));
    }
  }

  void _navigateToWorkoutRecordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutRecordPage(initialDate: selectedDate),
      ),
    );
  }

  Future<void> fetchFollowData() async {
    // 더미 데이터 사용 (백엔드 연동 시 API 호출로 대체)
    setState(() {
      followers = 120;  // 예시 팔로워 수
      following = 80;   // 예시 팔로잉 수
    });
  }

  Future<List<Post>> fetchUserPosts(int userId) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/posts/$userId"));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Post.fromJson(data))
          .where((post) => post.authorId == userId)
          .toList();
    } else {
      throw Exception('Failed to load posts');
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
        Expanded(child: _buildCustomCalendar()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: ElevatedButton(
            onPressed: _navigateToWorkoutRecordPage,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '총 3일 운동 완료',
                    style: TextStyle(color: Colors.yellow, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.white54, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('팔로워', style: TextStyle(color: Colors.white)),
                  Text('$followers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: 140),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('팔로잉', style: TextStyle(color: Colors.white)),
                  Text('$following', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.white54, thickness: 1),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: fetchUserPosts(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('게시글이 없습니다.', style: TextStyle(color: Colors.white)));
              }
              return GridView.builder(
                padding: EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return Container(
                    color: Colors.grey[800],
                    child: Column(
                      children: [
                        if (post.imageUrl != null)
                          Expanded(
                            child: Image.network(
                              post.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Image Load Error: $error');
                                return Icon(Icons.image_not_supported, color: Colors.white);
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            post.content,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
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
              side: BorderSide(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
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
          Color dayColor = Colors.white;
          if (day == '일') {
            dayColor = Colors.red;
          } else if (day == '토') {
            dayColor = Colors.blue;
          }
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(color: dayColor, fontWeight: FontWeight.bold),
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

        Color textColor = Colors.white;
        if (daysInMonth[index].weekday == DateTime.sunday) {
          textColor = Colors.red;
        } else if (daysInMonth[index].weekday == DateTime.saturday) {
          textColor = Colors.blue;
        }

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
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
