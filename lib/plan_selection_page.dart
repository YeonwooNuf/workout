import 'package:flutter/material.dart';

class PlanSelectionPage extends StatefulWidget {
  @override
  _PlanSelectionPageState createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PlanSelectionPage> {
  // 현재 선택된 플랜을 저장하는 상태 변수
  Map<String, String>? _currentPlan = {
    'plan': '근육량 증가 추천 플랜 (입문)',
  };

  // 사용자가 플랜을 선택했을 때 호출되는 함수
  void _selectPlan(Map<String, String> selectedPlan) {
    // 확인 대화 상자를 띄움
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('플랜 변경'),
          content: Text('플랜을 변경하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('예'),
              onPressed: () {
                setState(() {
                  // 선택된 플랜을 현재 플랜으로 업데이트
                  _currentPlan = selectedPlan;
                });

                // 화면 하단에 "플랜이 변경되었습니다." 알림 표시 (SnackBar 사용)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('플랜이 변경되었습니다.'),
                    duration: Duration(seconds: 2), // 2초 동안 알림 유지
                    backgroundColor: Color.fromARGB(100, 255, 255, 255),
                  ),
                );

                // 선택한 플랜 데이터를 반환
                Navigator.of(context).pop(selectedPlan); // 데이터 반환
              },
            ),
            TextButton(
              child: Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
          ],
        );
      },
    ).then((value) {
    if (value != null) {
      Navigator.of(context).pop(value); // 선택된 값으로 PlanSelectionPage 닫기
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('플랜 선택', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // 현재 선택된 플랜을 보여주는 카드
          CurrentPlanCard(currentPlan: _currentPlan),
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '근육량 증가 추천 플랜 (초급)',
              });
            },
            child: PlanCard(
              title: '근육량 증가 추천 플랜 (초급)',
              description: '주요 근육들에 집중하여 근육의 탄탄함을 향상시키세요.',
              imagePath: 'assets/images/muscle_gain.jpg',
            ),
          ),
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '체지방 감소 추천 플랜 (초급)',
              });
            },
            child: PlanCard(
              title: '체지방 감소 추천 플랜 (초급)',
              description: '기본적인 유산소 운동으로 체지방 감소를 시작해 보세요!',
              imagePath: 'assets/images/fat_loss.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '근육량 증가 추천 플랜 (중급)',
              });
            },
            child: PlanCard(
              title: '근육량 증가 추천 플랜 (중급)',
              description: '주요 근육들에 집중하여 근육의 탄탄함을 향상시키세요.',
              imagePath: 'assets/images/muscle_gain.jpg',
            ),
          ),
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '체지방 감소 추천 플랜 (중급)',
              });
            },
            child: PlanCard(
              title: '체지방 감소 추천 플랜 (중급)',
              description: '기본적인 유산소 운동으로 체지방 감소를 시작해 보세요!',
              imagePath: 'assets/images/fat_loss.png',
            ),
          ),
        ],
      ),
    );
  }
}

// 현재 선택된 플랜을 보여주는 카드 위젯
class CurrentPlanCard extends StatelessWidget {
  final Map<String, String>? currentPlan;

  CurrentPlanCard({required this.currentPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.fitness_center, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('지금은 이 플랜으로 운동하고 있어요!',
                    style: TextStyle(color: Colors.teal, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  currentPlan?['plan'] ?? '플랜을 선택하세요',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 개별 플랜을 나타내는 카드 위젯
class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  PlanCard(
      {required this.title,
      required this.description,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.asset(imagePath,
                fit: BoxFit.cover, height: 150, width: double.infinity),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 8.0),
                Text(description, style: TextStyle(color: Colors.grey[400])),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('자세히 보기'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
