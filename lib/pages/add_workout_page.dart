import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AddWorkoutPage extends StatefulWidget {
  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _workoutName = '';
  String _guide = '';
  String _selectedBodyPart = '가슴';
  Uint8List? _imageData;
  String? _imageName;

  final List<String> _bodyParts = [
    '가슴',
    '등',
    '하체',
    '어깨',
    '코어',
    '삼두',
    '이두',
    '전완근',
    '유산소'
  ];

  // 이미지 선택 메서드: file_picker 사용 (웹과 모바일 모두 호환)
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // 이미지 데이터를 Uint8List로 가져오기 위해 설정
    );

    if (result != null) {
      setState(() {
        _imageData = result.files.single.bytes;
        _imageName = result.files.single.name;
      });
    }
  }

  // 운동 추가 메서드
  Future<void> _addWorkout(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var uri = Uri.parse('http://10.0.2.2:8080/api/workouts/add');
      var request = http.MultipartRequest('POST', uri);
      request.fields['workoutName'] = _workoutName;
      request.fields['guide'] = _guide;
      request.fields['bodyPart'] = _selectedBodyPart;

      if (_imageData != null && _imageName != null) {
        var mimeType = lookupMimeType(_imageName!);
        request.files.add(
          http.MultipartFile.fromBytes(
            'workoutImage',
            _imageData!,
            filename: _imageName,
            contentType: MediaType.parse(mimeType!),
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('운동이 성공적으로 추가되었습니다!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('운동 추가 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 추가하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '운동 이름',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '운동 이름을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _workoutName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: '운동 방법 (가이드)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '운동 방법을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _guide = value!;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBodyPart,
                  items: _bodyParts
                      .map((part) => DropdownMenuItem(
                            value: part,
                            child: Text(part),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBodyPart = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '운동 부위 선택',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      _imageData != null
                          ? Image.memory(
                              _imageData!,
                              height: 150,
                            )
                          : Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.add_a_photo),
                        label: Text('운동 사진 업로드'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _addWorkout(context),
                    child: Text('운동 추가'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
