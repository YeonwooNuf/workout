import 'package:flutter/material.dart';

class WorkoutGuidePage extends StatelessWidget {
  final String workoutName;
  final String guide;
  final String workoutImage;

  WorkoutGuidePage({
    required this.workoutName,
    required this.guide,
    required this.workoutImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            workoutImage.isNotEmpty
                ? Image.network(
                    'http://10.0.2.2' + workoutImage,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 200); // 이미지 로드 실패 시 아이콘 표시
                    },
                  )
                : Icon(Icons.image, size: 200),
            SizedBox(height: 20),
            Text(
              workoutName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              guide,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
