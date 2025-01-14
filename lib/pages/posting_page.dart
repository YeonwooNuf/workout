import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostCreationPage extends StatefulWidget {
  final Function(String content, File? imageFile) onPostCreated;

  PostCreationPage({required this.onPostCreated});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시물 올리기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("내용", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: "게시글 내용을 입력해주세요",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo),
              label: Text("사진/영상 추가"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onPostCreated(_contentController.text, _selectedImage);
                Navigator.pop(context);
              },
              child: Text("완료"),
            ),
          ],
        ),
      ),
    );
  }
}
