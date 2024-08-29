import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _timeController = TextEditingController();

  List<double> weights = List.filled(7, 0.0);
  List<double> calories = List.filled(7, 0.0);
  List<double> times = List.filled(7, 0.0);
  List<String> dates = List.generate(7, (index) {
    return DateFormat('MM.dd').format(DateTime.now().subtract(Duration(days: 6 - index)));
  });

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _caloriesController.dispose();
    _timeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _addData() {
    setState(() {
      weights.removeAt(0);
      weights.add(double.tryParse(_weightController.text) ?? 0);
      calories.removeAt(0);
      calories.add(double.tryParse(_caloriesController.text) ?? 0);
      times.removeAt(0);
      times.add(double.tryParse(_timeController.text) ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 분석'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '무게'),
            Tab(text: '칼로리'),
            Tab(text: '시간'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('운동 기록 입력', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '무게 (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '칼로리 (kcal)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '운동 시간 (분)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addData,
              child: Text('기록 저장'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChart(weights, '무게 (kg)'),
                  _buildChart(calories, '칼로리 (kcal)'),
                  _buildChart(times, '운동 시간 (분)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // fl_chart 버전 0.67.0 사용했는데 좀 최신이라 안되는거 있을 수도
  Widget _buildChart(List<double> data, String yAxisLabel) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(dates[value.toInt()]);
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: data.reduce((a, b) => a > b ? a : b) + 10,
      ),
    );
  }
}
