import 'package:flutter/material.dart';
import 'package:workout/pages/workout_list_page.dart';

class WorkoutRecordPage extends StatefulWidget {
  final DateTime initialDate;

  WorkoutRecordPage({Key? key, required this.initialDate}) : super(key: key);

  @override
  _WorkoutRecordPageState createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  late DateTime selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  String selectedCategory = "헬스";

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1C1E),
        title: Text('운동 기록', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("헬스"),
                _buildCategoryButton("홈트"),
                
              ],
            ),
            SizedBox(height: 24),

            // 날짜 및 시간 선택 위젯
            _buildDateTimePicker("날짜 및 시간", selectedDate, selectedTime),

            SizedBox(height: 24),

            // 운동한 시간 입력 필드
            _buildDurationPicker(),

            SizedBox(height: 18),

            Divider(
              color: Colors.grey, // 구분선 색상
              thickness: 1.0, // 구분선 두께
              indent: 12.0, // 시작 지점 여백
              endIndent: 12.0, // 끝 지점 여백
            ),

            SizedBox(height: 18),

            // 상세 기록 입력 필드
            _buildDetailInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    bool isSelected = selectedCategory == label; // 현재 선택 상태 확인
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; // 선택된 카테고리 업데이트
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.transparent, // 선택된 경우 배경색 적용
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.greenAccent : Colors.white, // 선택된 경우 글자 색상 변경
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget _buildDateTimePicker(String label, DateTime date, TimeOfDay time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        GestureDetector(
          onTap: () async {
            await _selectDate(context);
            await _selectTime(context);
          },
          child: Container(
            width: 206, // 날짜 박스 너비 설정
            padding: EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 4.0), // 내부 여백 설정
            decoration: BoxDecoration(
              color: Colors.grey[800], // 배경색 설정
              borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
            ),
            child: Text(
              "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${time.format(context)}",
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "운동한 시간",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        Row(
          children: [
            // 시 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            // 시와 분 사이 구분자
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(":",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            // 분 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            // 분과 초 사이 구분자
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(":",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            // 초 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "상세 기록 (선택)",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text("운동 보기", style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPage())
                  );
                },             
              ),
              Icon(Icons.add, color: Colors.greenAccent),
            ],
          ),
        ),
      ],
    );
  }
}
