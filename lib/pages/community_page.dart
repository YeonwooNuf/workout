import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:workout/pages/profile_page.dart';
import 'dart:convert';
import 'posting_page.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Post> posts = [];
  String? currentUser;
  final String apiUrl = "http://10.0.2.2:8080/api/posts";

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchPosts();
  }

  Future<void> fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('loggedInUsername');
    });
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          posts = (json.decode(response.body) as List)
              .map((data) => Post.fromJson(data))
              .toList();
        });
      } else {
        print("Failed to fetch posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> uploadPost(String content, File? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('loggedInUserId'); // ✅ userId 가져오기

    if (userId == null) {
      print("🚨 Error: User ID not found. Please log in again.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인이 필요합니다. 다시 로그인해주세요.")),
      );
      return;
    }

    var uri = Uri.parse("http://10.0.2.2:8080/api/posts/$userId");
    var request = http.MultipartRequest("POST", uri);

    request.fields['content'] = content;
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("✅ 게시글 업로드 성공!");
      } else {
        print("🚨 게시글 업로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error uploading post: $e");
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        fetchPosts();
      } else {
        print("Failed to delete post: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("커뮤니티"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int? userId = prefs.getInt('loggedInUserId');  // ✅ userId 가져오기

              if (currentUser != null && userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: userId, username: currentUser!),  // ✅ userId 추가
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("로그인 정보가 없습니다. 다시 로그인해주세요.")),
                );
              }
            },
          )

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white38,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("작성자: ${post.author}", style: TextStyle(color: Colors.grey[500], fontSize: 14.0)),
                                  if (post.author == currentUser)
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.white30),
                                      onPressed: () => deletePost(post.id),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(post.content, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                              if (post.imageUrl != null)
                                Image.network(
                                  post.imageUrl!.startsWith("http")
                                      ? post.imageUrl!
                                      : "http://10.0.2.2:8080" + post.imageUrl!,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // ✅ 글과 글 사이의 간격 조절
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostCreationPage(onPostCreated: uploadPost),
            ),
          );
          fetchPosts(); // 새 게시글 업로드 후 목록 새로고침
        },
        child: Icon(Icons.add),
      ),
    );
  }
}