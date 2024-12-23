import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'workout_guide_page.dart'; // 가이드 페이지 import

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> filteredWorkouts = [];
  List<String> selectedBodyParts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  // 운동 목록 가져오기
  Future<void> fetchWorkouts() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/api/workouts')); // 여기를 서버 URL로 바꾸세요.

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩하여 한글 깨짐 방지
      setState(() {
        workouts = data
            .map((item) => {
                  'workoutName': item['workoutName'],
                  'guide': item['guide'],
                  'bodyPart': item['bodyPart'],
                  'workoutImage': item[
                      'workoutImagePath'], // 경로는 "/images/filename.png" 형식으로 반환
                })
            .toList();
        filteredWorkouts = List.from(workouts); // 전체 리스트 초기화
      });
    } else {
      print('Failed to load workouts');
    }
  }

  // 필터링 함수
  void filterWorkouts() {
    setState(() {
      filteredWorkouts = workouts.where((workout) {
        final workoutNameWithoutSpaces =
            workout['workoutName'].replaceAll(' ', '').toLowerCase();
        final searchQueryWithoutSpaces =
            searchQuery.replaceAll(' ', '').toLowerCase();

        final matchesSearch =
            workoutNameWithoutSpaces.contains(searchQueryWithoutSpaces);
        final matchesBodyPart = selectedBodyParts.isEmpty ||
            selectedBodyParts.contains(workout['bodyPart']);
        return matchesSearch && matchesBodyPart;
      }).toList();
    });
  }

  void toggleBodyPartSelection(String bodyPart) {
    setState(() {
      if (selectedBodyParts.contains(bodyPart)) {
        selectedBodyParts.remove(bodyPart);
      } else {
        selectedBodyParts.add(bodyPart);
      }
      filterWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 목록'),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                filterWorkouts();
              },
              decoration: InputDecoration(
                labelText: '운동 이름 검색',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // 부위 필터 버튼
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['가슴', '등', '하체', '어깨', '삼두', '이두', '코어']
                  .map((part) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          onPressed: () => toggleBodyPartSelection(part),
                          child: Text(
                            part,
                            style: TextStyle(
                              fontSize: 18, // 글씨 크기
                              color: selectedBodyParts.contains(part)
                                  ? Colors.teal
                                  : Colors.white, // 선택 시 글자 색상 변경
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // 선택한 항목에서 리스트에 총 몇 개의 운동이 떠있는지 표시
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Text(
                '전체 ${filteredWorkouts.length}개', // 필터링된 운동의 개수를 표시
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
              ),
            ),
          ),
          Expanded(
            child: filteredWorkouts.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return GestureDetector(
                        onTap: () => navigateToGuidePage(
                          context,
                          workout['workoutName'],
                          workout['guide'],
                          workout['workoutImage'] ?? '',
                        ),
                        child: Container(
                          color: Colors.transparent, // 클릭 가능하도록 투명한 배경 색 지정
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // 이미지와 텍스트를 세로로 중앙 정렬
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0), // 이미지 양 옆에 여백 추가
                                      child: Container(
                                        width: 100, // 이미지의 원하는 너비 설정
                                        height: 100, // 이미지의 원하는 높이 설정
                                        child: workout['workoutImage'] != null
                                            ? Image.network(
                                                'http://localhost:8080' +
                                                    workout[
                                                        'workoutImage'], // 이미지 경로와 서버 URL을 합쳐서 완전한 경로로 만들기
                                                fit: BoxFit
                                                    .contain, // 이미지 비율을 유지하면서 크기를 조정
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                      Icons.broken_image,
                                                      size:
                                                          150); // 이미지 로드 실패 시 아이콘 표시
                                                },
                                              )
                                            : Icon(Icons.image, size: 150),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // 텍스트를 Column 내에서 중앙 정렬
                                        children: [
                                          Text(
                                            workout['workoutName'],
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight
                                                    .bold), // 글씨 크기 조정
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            workout['bodyPart'],
                                            style: TextStyle(
                                                fontSize: 18), // 글씨 크기 조정
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0), // 구분선 양 끝에 여백 추가
                                child: Divider(
                                  thickness: 1, // 구분선 두께 설정
                                  height: 10, // 높이를 더 주어 중앙에 위치하도록 설정
                                  color: Colors.grey[700], // 구분선 색상 설정
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child:
                        CircularProgressIndicator(), // 데이터 로딩 중일 때 로딩 인디케이터 표시
                  ),
          ),
        ],
      ),
    );
  }

  void navigateToGuidePage(BuildContext context, String workoutName,
      String guide, String workoutImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutGuidePage(
          workoutName: workoutName,
          guide: guide,
          workoutImage: workoutImage,
        ),
      ),
    );
  }
}
