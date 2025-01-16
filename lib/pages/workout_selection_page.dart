import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkoutSelectionPage extends StatefulWidget {
  final String selectedPlan;
  final String selectedDay;
  final String selectedTime;

  WorkoutSelectionPage(
      {required this.selectedPlan,
      required this.selectedDay,
      required this.selectedTime});

  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> recommendedWorkouts = [];
  bool isLoading = true;
  bool isReordering = false;

  @override
  void initState() {
    super.initState();
    fetchWorkouts(); // 운동 데이터 가져오기
  }

  // 서버에서 운동 목록 가져오기
  Future<void> fetchWorkouts() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/workouts')); // 서버 URL 수정
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          workouts = data
              .map((item) => {
                    'workoutName': item['workoutName'],
                    'guide': item['guide'],
                    'bodyPart': item['bodyPart'],
                    'workoutImage': item['workoutImagePath'],
                  })
              .toList();
          generateRecommendedWorkouts(); // 추천 운동 생성
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 선택된 플랜과 Day에 따라 추천 운동 생성
  void generateRecommendedWorkouts() {
    Random random = Random();
    recommendedWorkouts.clear();

    if (widget.selectedPlan.contains('기본')) {
      recommendedWorkouts = _getRandomWorkouts(['가슴'], 2) +
          _getRandomWorkouts(['등'], 2) +
          _getRandomWorkouts(['어깨'], 1) +
          _getRandomWorkouts(['하체'], 2);
    } else if (widget.selectedPlan.contains('초급')) {
      if (widget.selectedDay == 'Day 1') {
        recommendedWorkouts =
            _getRandomWorkouts(['가슴'], 4) + _getRandomWorkouts(['삼두'], 2);
      } else if (widget.selectedDay == 'Day 2') {
        recommendedWorkouts =
            _getRandomWorkouts(['등'], 4) + _getRandomWorkouts(['이두'], 2);
      } else if (widget.selectedDay == 'Day 3') {
        recommendedWorkouts =
            _getRandomWorkouts(['하체'], 3) + _getRandomWorkouts(['어깨'], 3);
      }
    } else if (widget.selectedPlan.contains('중급')) {
      if (widget.selectedDay == 'Day 1') {
        recommendedWorkouts =
            _getRandomWorkouts(['가슴'], 4) + _getRandomWorkouts(['삼두'], 2);
      } else if (widget.selectedDay == 'Day 2') {
        recommendedWorkouts =
            _getRandomWorkouts(['등'], 4) + _getRandomWorkouts(['이두'], 2);
      } else if (widget.selectedDay == 'Day 3') {
        recommendedWorkouts =
            _getRandomWorkouts(['어깨'], 3) + _getRandomWorkouts(['코어'], 3);
      } else if (widget.selectedDay == 'Day 4') {
        recommendedWorkouts =
            _getRandomWorkouts(['하체'], 3) + _getRandomWorkouts(['코어'], 3);
      }
    } else if (widget.selectedPlan.contains('고급')) {
      if (widget.selectedDay == 'Day 1') {
        recommendedWorkouts =
            _getRandomWorkouts(['가슴'], 4) + _getRandomWorkouts(['삼두'], 1);
      } else if (widget.selectedDay == 'Day 2') {
        recommendedWorkouts =
            _getRandomWorkouts(['등'], 4) + _getRandomWorkouts(['이두'], 1);
      } else if (widget.selectedDay == 'Day 3') {
        recommendedWorkouts =
            _getRandomWorkouts(['어깨'], 3) + _getRandomWorkouts(['코어'], 3);
      } else if (widget.selectedDay == 'Day 4') {
        recommendedWorkouts =
            _getRandomWorkouts(['이두'], 3) + _getRandomWorkouts(['삼두'], 3);
      } else if (widget.selectedDay == 'Day 5') {
        recommendedWorkouts =
            _getRandomWorkouts(['하체'], 4) + _getRandomWorkouts(['코어'], 2);
      }
    }
  }

  // 특정 부위에서 랜덤으로 운동 선택
  List<Map<String, dynamic>> _getRandomWorkouts(
      List<String> bodyParts, int count) {
    Random random = Random();
    List<Map<String, dynamic>> filteredWorkouts = workouts
        .where((workout) => bodyParts.contains(workout['bodyPart']))
        .toList();
    filteredWorkouts.shuffle(random); // 무작위 정렬
    return filteredWorkouts.take(count).toList(); // 지정된 개수만큼 선택
  }

  // 셔플 로직
  void reorderWorkoutList(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final workout = recommendedWorkouts.removeAt(oldIndex);
      recommendedWorkouts.insert(newIndex, workout);
    });
  }

  @override
  Widget build(BuildContext context) {
    // main_page에서 선택된 시간 값을 표현
    String timeLabel = widget.selectedTime;

    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 추천 운동'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : Column(
              children: [
                // 상단 정보 (총 운동 개수, 예상 소요 시간)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // 텍스트와 아이콘 정렬
                    children: [
                      Text(
                        '총 ${recommendedWorkouts.length}개 | $timeLabel',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isReordering ? Icons.check : Icons.sort),
                            onPressed: () {
                              setState(() {
                                isReordering =
                                    !isReordering; // Toggle reordering mode
                              });
                            },
                          ),
                          SizedBox(width: 8), // 아이콘 간 간격
                          IconButton(
                            icon: Icon(Icons.shuffle),
                            onPressed: isReordering
                                ? null // 순서 변경(토글 모드) 중에는 셔플 비활성화
                                : () {
                                    setState(() {
                                      generateRecommendedWorkouts(); // 셔플
                                    });
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isReordering
                      ? ReorderableListView(
                          // 순서 수정 모드
                          onReorder: reorderWorkoutList,
                          children: recommendedWorkouts
                              .asMap()
                              .map((index, workout) => MapEntry(
                                    index,
                                    ListTile(
                                      key: ValueKey(index),
                                      leading: workout['workoutImage'] != null
                                          ? Image.network(
                                              'http://10.0.2.2:8080' +
                                                  workout['workoutImage'],
                                              width: 80,
                                              height: 80,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons.fitness_center),
                                            )
                                          : Icon(Icons.fitness_center),
                                      title: Text(
                                        workout['workoutName'],
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        '세트 수 X 무게 X 반복횟수',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ))
                              .values
                              .toList(),
                        )
                      : ListView.builder(
                          // 기본 모드
                          itemCount: recommendedWorkouts.length,
                          itemBuilder: (context, index) {
                            final workout = recommendedWorkouts[index];
                            return ListTile(
                              leading: workout['workoutImage'] != null
                                  ? Image.network(
                                      'http://10.0.2.2:8080' +
                                          workout['workoutImage'],
                                      width: 80,
                                      height: 80,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.fitness_center),
                                    )
                                  : Icon(Icons.fitness_center),
                              title: Text(
                                workout['workoutName'],
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '세트 수 X 무게 X 반복횟수',
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                ),
                // 시작하기 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // 운동 시작 기능 추가 가능
                    },
                    child: Text('시작하기', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
