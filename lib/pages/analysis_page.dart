import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  // 날짜별 총 운동 시간 데이터 (예제 데이터)
  List<double> totalWorkoutTimes = [50, 60, 45, 70, 90, 40, 80];

  // 최근 7일의 날짜
  List<String> dates = List.generate(7, (index) {
    return DateFormat('MM.dd')
        .format(DateTime.now().subtract(Duration(days: 6 - index)));
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 분석'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 7일 총 운동 시간',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(child: _buildWorkoutTimeChart()),
          ],
        ),
      ),
    );
  }

  // 날짜별 총 운동 시간 차트
  Widget _buildWorkoutTimeChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          // x축 날짜
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dates[value.toInt()],
                    style: TextStyle(fontSize: 12),
                  ),
                );
              },
              interval: 1,
            ),
          ),
          // y축 운동 시간
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.toInt()}분',
                    style: TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.transparent, width: 20),
            top: BorderSide(color: Colors.transparent, width: 20),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: totalWorkoutTimes.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: Colors.teal,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: totalWorkoutTimes.reduce((a, b) => a > b ? a : b) + 10,
      ),
    );
  }
}
