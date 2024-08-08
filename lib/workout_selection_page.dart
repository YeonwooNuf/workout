import 'package:flutter/material.dart';

class WorkoutSelectionPage extends StatelessWidget {
  final List<String> workoutParts = [
    '전신', '상체', '하체', '복근', '팔', '등', '가슴', '어깨'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 부위 선택'),
      ),
      body: ListView.builder(
        itemCount: workoutParts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workoutParts[index]),
            onTap: () {
              Navigator.pop(context, workoutParts[index]);
            },
          );
        },
      ),
    );
  }
}
