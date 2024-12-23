// kcal_calculate.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionixService {
  final String appId = '1495afbc'; // 발급받은 App ID
  final String apiKey = '6858b74a9ea67a46b66b97f6db4b79fb'; // 발급받은 API Key

  Future<double?> calculateCalories(String exercise, double weight, int duration) async {
    final url = Uri.parse('https://trackapi.nutritionix.com/v2/natural/exercise');

    final headers = {
      'Content-Type': 'application/json',
      'x-app-id': appId,
      'x-app-key': apiKey,
    };

    final body = jsonEncode({
      "query": exercise,
      "weight_kg": weight,
      "duration_min": duration,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final calories = data['exercises'][0]['nf_calories'];
        return calories;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}

class KcalCalculatePage extends StatefulWidget {
  @override
  _KcalCalculatePageState createState() => _KcalCalculatePageState();
}

class _KcalCalculatePageState extends State<KcalCalculatePage> {
  final _nutritionixService = NutritionixService();
  double? caloriesBurned;

  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void calculateCalories() async {
    final exercise = _exerciseController.text;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final duration = int.tryParse(_durationController.text) ?? 0;

    final calories = await _nutritionixService.calculateCalories(exercise, weight, duration);
    setState(() {
      caloriesBurned = calories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("운동 칼로리 계산기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _exerciseController,
              decoration: InputDecoration(labelText: "운동 이름 (예: running)"),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: "몸무게 (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: "운동 시간 (분)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("칼로리 계산"),
            ),
            SizedBox(height: 20),
            if (caloriesBurned != null)
              Text(
                "소모된 칼로리: ${caloriesBurned!.toStringAsFixed(2)} kcal",
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
