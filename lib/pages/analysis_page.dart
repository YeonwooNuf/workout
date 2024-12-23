import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  // 데이터 (무게, 칼로리, 시간) 리스트
  List<double> weights = List.filled(7, 0.0); // 무게 데이터
  List<double> calories = List.filled(7, 0.0); // 칼로리 데이터
  List<double> times = List.filled(7, 0.0); // 운동 시간 데이터

  // 최근 7일의 날짜
  List<String> dates = List.generate(7, (index) {
    return DateFormat('MM.dd')
        .format(DateTime.now().subtract(Duration(days: 6 - index)));
  });

  // TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TabController 초기화 (총 3개의 탭: 무게, 칼로리, 시간)
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 분석'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '무게'), // 무게 탭
            Tab(text: '칼로리'), // 칼로리 탭
            Tab(text: '시간'), // 시간 탭
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 그래프 위에 "최근 7일 기록" 제목 추가
            Text('최근 7일 기록',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20), // 제목과 그래프 사이 여백
            // TabBarView로 차트들을 표시
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChart(weights, '무게 (kg)'), // 무게 차트
                  _buildChart(calories, '칼로리 (kcal)'), // 칼로리 차트
                  _buildChart(times, '운동 시간 (분)'), // 운동 시간 차트
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 차트를 생성하는 함수
    Widget _buildChart(List<double> data, String yAxisLabel) {
  return LineChart(
    LineChartData(
      gridData: FlGridData(show: true),  // 그리드 표시
      titlesData: FlTitlesData(
        // x축에 날짜를 표시
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,  // x축 타이틀을 위한 공간
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  dates[value.toInt()],
                  style: TextStyle(fontSize: 12),  // 날짜 텍스트 크기
                ),
              );
            },
            interval: 1,  // 날짜 간격 설정
          ),
        ),
        // y축에 데이터 값 표시 (왼쪽)
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,  // y축 타이틀을 위한 공간
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  value.toString(),
                  style: TextStyle(fontSize: 12),  // y축 텍스트 크기
                ),
              );
            },
          ),
        ),
        // 상단 타이틀 숨기기
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,  // 상단 타이틀 숨김
          ),
        ),
        // 우측 타이틀 숨기기
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,  // 우측 타이틀 숨김
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,  // 테두리 표시
        border: Border(
          left: BorderSide(color: Colors.black, width: 1),  // 왼쪽 테두리
          bottom: BorderSide(color: Colors.black, width: 1),  // 하단 테두리
          right: BorderSide(color: Colors.transparent, width: 20),  // 우측에 마진 추가
          top: BorderSide(color: Colors.transparent, width: 20),  // 상단에 마진 추가
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
          isCurved: true,  // 곡선 차트
          color: Colors.blue,  // 차트 선 색상
          barWidth: 4,  // 차트 선 두께
          isStrokeCapRound: true,  // 차트 끝을 둥글게
          belowBarData: BarAreaData(show: false),  // 하단 음영 없음
        ),
      ],
      minX: 0,  // x축 최소값
      maxX: 6,  // x축 최대값
      minY: 0,  // y축 최소값
      maxY: data.reduce((a, b) => a > b ? a : b) + 10,  // y축 최대값 (데이터 중 가장 큰 값 + 여유값)
    ),
  );
}

}
