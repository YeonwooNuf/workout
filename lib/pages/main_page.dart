import 'package:flutter/material.dart';
import 'package:workout/widget/setting.dart';
import 'plan_selection_page.dart';
import 'workout_selection_page.dart';
import 'setting_page.dart';

class MainPage extends StatefulWidget {
  Map<String, String> selectedPlan; // final 제거하여 수정 가능하게 변경
  final String username;

  MainPage({required this.selectedPlan, required this.username});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 선택된 값들을 저장하는 변수들
  String selectedDay = 'Day 1';
  List<String> days = []; // days 목록을 여기에 선언합니다.

  @override
  void initState() {
    super.initState();
    _setDaysBasedOnPlan(); // 초기화 시 days 설정
    _updateWorkoutPart(); // 초기화 시 운동 부위 설정
  }

  String selectedTime = '보통';
  String selectedCondition = '100%';
  String selectedWorkoutPart = '';
  // String currentPlan = '근육량 증가 추천 플랜 (입문)';

  int totalCalories = 309;
  int workoutCount = 5;
  int setCount = 20;

  
  final List<String> times = ['짧게', '조금 짧게', '보통', '조금 길게', '길게'];
  final List<String> conditions = ['25%', '50%', '75%', '100%', '125%'];

  // 선택된 플랜에 따라 days 목록을 설정하는 메서드
  void _setDaysBasedOnPlan() {
    String? plan = widget.selectedPlan['plan'];
    if (plan != null) {
      if (plan.contains('초급')) {
        days = ['Day 1', 'Day 2', 'Day 3'];
        workoutCount = 6;
      } else if (plan.contains('중급')) {
        days = ['Day 1', 'Day 2', 'Day 3', 'Day 4'];
        workoutCount = 6;
      } else if (plan.contains('고급')) {
        days = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'];
        // if (days = ['Day 1', 'Day 2']) {

        // }
      } else {
        days = ['Day 1']; // 기본값 설정
      }
      selectedDay = days.first; // 초기 선택을 첫 번째 Day로 설정
    }
    _updateWorkoutPart(); // days 변경 시 운동 부위 업데이트
  }

  // 컨디션 선택을 위한 BottomSheet를 표시하는 메서드
  void _showConditionBottomSheet() {
    String tempSelectedCondition = selectedCondition;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('신체 컨디션',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('오늘의 컨디션에 맞춰 운동 강도를 조절해드려요.',
                        style: TextStyle(color: Colors.white70)),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: conditions
                          .map((condition) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tempSelectedCondition == condition
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: tempSelectedCondition == condition
                                        ? Colors.teal.withOpacity(0.3)
                                        : null,
                                  ),
                                  child: ListTile(
                                    title: Text(condition,
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text(
                                        _getConditionDescription(condition),
                                        style:
                                            TextStyle(color: Colors.white70)),
                                    onTap: () {
                                      setModalState(() {
                                        tempSelectedCondition = condition;
                                      });
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text('선택하기'),
                      onPressed: () {
                        setState(() {
                          selectedCondition = tempSelectedCondition;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 각 컨디션에 대한 설명을 반환하는 메서드
  String _getConditionDescription(String condition) {
    switch (condition) {
      case '125%':
        return '컨디션이 평소보다 훨씬 좋습니다.';
      case '100%':
        return '평소와 같은 상태입니다.';
      case '75%':
        return '몸이 무겁게 느껴집니다.';
      case '50%':
        return '피곤하고 기운이 없습니다.';
      case '25%':
        return '몸 상태가 매우 좋지 않습니다.';
      default:
        return '';
    }
  }

  void _showTimeBottomSheet() {
    String tempSelectedTime = selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('운동 시간',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('선택한 시간에 맞게 운동량을 조절해드려요.',
                        style: TextStyle(color: Colors.white70)),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: times
                          .map((time) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tempSelectedTime == time
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: tempSelectedTime == time
                                        ? Colors.teal.withOpacity(0.3)
                                        : null,
                                  ),
                                  child: ListTile(
                                    title: Text(time,
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text(_getTimeDescription(time),
                                        style:
                                            TextStyle(color: Colors.white70)),
                                    onTap: () {
                                      setModalState(() {
                                        tempSelectedTime = time;
                                      });
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text('선택하기'),
                      onPressed: () {
                        setState(() {
                          selectedTime = tempSelectedTime;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 각 운동 시간에 대한 설명을 반환하는 메서드
  String _getTimeDescription(String time) {
    switch (time) {
      case '짧게':
        return '약 30분';
      case '조금 짧게':
        return '약 45분';
      case '보통':
        return '약 1시간';
      case '조금 길게':
        return '약 1시간 15분';
      case '길게':
        return '약 1시간 30분';
      default:
        return '';
    }
  }

  // 선택된 Day와 Plan에 따라 운동 부위를 업데이트
  void _updateWorkoutPart() {
    setState(() {
      selectedWorkoutPart = _getWorkoutPartByDay(selectedDay);
    });
  }

  // Day와 Plan에 따라 운동 부위를 반환
  String _getWorkoutPartByDay(String day) {
    String? plan = widget.selectedPlan['plan'];
    if (plan != null) {
      if (plan.contains('기본')) {
        if (day == 'Day 1') return '가슴, 등, 어깨';
      } else if (plan.contains('초급')) {
        if (day == 'Day 1') return '가슴, 삼두';
        if (day == 'Day 2') return '등, 이두';
        if (day == 'Day 3') return '하체, 어깨';
      } else if (plan.contains('중급')) {
        if (day == 'Day 1') return '가슴, 삼두';
        if (day == 'Day 2') return '등, 이두';
        if (day == 'Day 3') return '어깨, 코어';
        if (day == 'Day 4') return '하체, 코어';
      } else if (plan.contains('고급')) {
        if (day == 'Day 1') return '가슴';
        if (day == 'Day 2') return '등';
        if (day == 'Day 3') return '어깨';
        if (day == 'Day 4') return '이두, 삼두';
        if (day == 'Day 5') return '하체';
      }
    }
    return '운동 부위 없음'; // 예외 처리
  }

  // Day 선택 BottomSheet
  void _showDayBottomSheet() {
    String tempSelectedDay = selectedDay;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('운동 일 선택',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: days
                          .map((day) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: tempSelectedDay == day
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: tempSelectedDay == day
                                        ? Colors.teal.withOpacity(0.3)
                                        : null,
                                  ),
                                  child: ListTile(
                                    title: Text(day,
                                        style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                      setModalState(() {
                                        tempSelectedDay = day;
                                      });
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: Text('선택하기'),
                      onPressed: () {
                        setState(() {
                          selectedDay = tempSelectedDay;
                          _updateWorkoutPart(); // Day 선택 시 운동 부위 업데이트
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 정보
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('헬스'),
        actions: [
          SettingsIcon(username: widget.username), // 공통 설정 아이콘 추가
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 제목과 '플랜 더보기' 버튼
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.selectedPlan['plan'] ?? '기본 플랜'}', // null일 경우 기본 플랜.
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlanSelectionPage(username: widget.username),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            widget.selectedPlan = result;
                            _setDaysBasedOnPlan(); // 플랜 변경 시 days 업데이트
                          });
                        }
                      },
                      child: Text(
                        '플랜 더보기',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                // Day, 시간, 컨디션 선택 위젯들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildDaySelector(size)),
                    SizedBox(width: 10),
                    Expanded(child: _buildTimeSelector(size)),
                    SizedBox(width: 10),
                    Expanded(child: _buildConditionSelector(size)),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                // 운동 정보 컨테이너
                _buildWorkoutInfoContainer(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(Size size) {
    return GestureDetector(
      onTap: _showDayBottomSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Text(selectedDay)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(Size size) {
    return GestureDetector(
      onTap: _showTimeBottomSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Text(selectedTime)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionSelector(Size size) {
    return GestureDetector(
      onTap: _showConditionBottomSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Text(selectedCondition)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutInfoContainer(Size size) {
  return GestureDetector(
    onTap: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSelectionPage(
            selectedPlan: widget.selectedPlan['plan'] ?? '기본 플랜',
            selectedDay: selectedDay,
            selectedTime: _getTimeDescription(selectedTime), // 선택된 시간을 전달
          ),
        ),
      );
      if (result != null && result is String) {
        setState(() {
          selectedWorkoutPart = result;
        });
      }
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // 운동 부위를 표시하는 텍스트 추가
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '운동 부위: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: selectedWorkoutPart,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(Icons.fitness_center, '$workoutCount개의 운동'),
              _buildInfoItem(Icons.timer, '$setCount세트'),
              _buildInfoItem(Icons.local_fire_department, '$totalCalories kcal'),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.02,
              ),
            ),
            child: Text('추천 운동 시작하기', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}
