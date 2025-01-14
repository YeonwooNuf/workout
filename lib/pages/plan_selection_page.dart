import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/service/sv_plans.dart'; // PlanService import

class PlanSelectionPage extends StatefulWidget {
  final String username; // username을 받아옴

  PlanSelectionPage({required this.username});

  @override
  _PlanSelectionPageState createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PlanSelectionPage> {
  final PlanService _planService = PlanService(); // PlanService 인스턴스 생성
  Map<String, String>? _currentPlan = {
    'plan': '근육량 증가 추천 플랜 (입문)',
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedPlan(); // 초기 로드 시 선택된 플랜 불러오기
  }

  // 서버에서 선택된 플랜 불러오기 및 로컬에 저장된 데이터 로드
  Future<void> _loadSelectedPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPlan = prefs.getString('selectedPlan_${widget.username}'); // 사용자별 플랜 정보 가져오기

    if (savedPlan != null) {
      setState(() {
        _currentPlan = {'plan': savedPlan}; // 로컬 저장소에서 선택된 플랜 불러오기
      });
    } else {
      final selectedPlan = await _planService.getSelectedPlan(widget.username); // 서버에서 플랜 정보 가져오기
      if (selectedPlan != null) {
        setState(() {
          _currentPlan = {'plan': selectedPlan['planName']};
        });
        // 사용자별 선택된 플랜 로컬에 저장
        await prefs.setString('selectedPlan_${widget.username}', selectedPlan['planName']);
      } else {
        setState(() {
          _currentPlan = {'plan': '기본 플랜'}; // 서버에서도 가져오지 못할 경우 기본값 설정
        });
      }
    }
  }

  // 사용자가 플랜을 선택했을 때 호출되는 함수
  void _selectPlan(Map<String, String> selectedPlan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('플랜 변경'),
          content: Text('플랜을 변경하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('예'),
              onPressed: () async {
                setState(() {
                  _currentPlan = selectedPlan;
                });

                final planName = selectedPlan['plan'] ?? '기본 플랜';
                final planId = _getPlanId(planName);

                try {
                  await _planService.selectPlan(widget.username, planId);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selectedPlan_${widget.username}', planName);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('플랜이 변경되었습니다.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('플랜 저장 중 오류가 발생했습니다.')),
                  );
                }

                Navigator.of(context).pop(selectedPlan);
              },
            ),
            TextButton(
              child: Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 플랜 이름에 따른 플랜 ID를 반환하는 메서드
  int _getPlanId(String planName) {
    switch (planName) {
      case '근육량 증가 추천 플랜 (초급)':
        return 1;
      case '체지방 감소 추천 플랜 (초급)':
        return 2;
      case '근육량 증가 추천 플랜 (중급)':
        return 3;
      case '체지방 감소 추천 플랜 (중급)':
        return 4;
      case '근육량 증가 추천 플랜 (초급)':
        return 5;
      case '체지방 감소 추천 플랜 (고급)':
        return 6;
      default:
        return 0; // 기본값 또는 오류 처리
    }
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
          onPressed: () => Navigator.pop(context, _currentPlan), // 현재 선택된 플랜을 반환
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
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
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '근육량 증가 추천 플랜 (고급)',
              });
            },
            child: PlanCard(
              title: '근육량 증가 추천 플랜 (고급)',
              description: '주요 근육들에 집중하여 근육의 탄탄함을 향상시키세요.',
              imagePath: 'assets/images/muscle_gain.jpg',
            ),
          ),
          GestureDetector(
            onTap: () {
              _selectPlan({
                'plan': '체지방 감소 추천 플랜 (고급)',
              });
            },
            child: PlanCard(
              title: '체지방 감소 추천 플랜 (고급)',
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

  PlanCard({
    required this.title,
    required this.description,
    required this.imagePath,
  });

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
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              height: 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400]),
                ),
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
