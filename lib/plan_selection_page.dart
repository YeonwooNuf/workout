import 'package:flutter/material.dart';

class PlanSelectionPage extends StatelessWidget {
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
          CurrentPlanCard(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                'plan': '근육량 증가 추천 플랜 (초급)',
                'day': 'Day 1',
                'workouts': '5개의 운동',
                'sets': '20세트',
                'calories': '309kcal'
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
              Navigator.pop(context, {
                'plan': '체지방 감소 추천 플랜 (입문)',
                'day': 'Day 1',
                'workouts': '4개의 운동',
                'sets': '15세트',
                'calories': '250kcal'
              });
            },
            child: PlanCard(
              title: '체지방 감소 추천 플랜 (입문)',
              description: '기본적인 유산소 운동으로 체지방 감소를 시작해 보세요!',
              imagePath: 'assets/images/fat_loss.png',
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentPlanCard extends StatelessWidget {
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
                Text('근육량 증가 추천 플랜 (입문)', 
                     style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  PlanCard({required this.title, required this.description, required this.imagePath});

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
            child: Image.asset(imagePath, fit: BoxFit.cover, height: 150, width: double.infinity),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 8.0),
                Text(description, style: TextStyle(color: Colors.grey[400])),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('플랜 더 알아보기'),
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