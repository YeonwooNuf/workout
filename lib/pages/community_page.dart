import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import
import 'posting_page.dart';
import 'profile_page.dart';

class Post {
  final int id;
  final String author;
  final String content;
  final String? imageUrl;

  Post({required this.id, required this.author, required this.content, this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['postImageUrl'] != null
        ? "http://10.0.2.2:8080${json['postImageUrl']}"
        : null;
    return Post(
      id: json['postId'],
      author: json['authorUsername'],
      content: json['content'],
      imageUrl: imageUrl,
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Post> posts = [];
  String? currentUser; // 로그인한 사용자 이름
  final String apiUrl = "http://10.0.2.2:8080/api/posts";

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // 현재 사용자 정보 로드
    fetchPosts(); // 게시글 로드
  }

  Future<void> fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('loggedInUsername'); // 저장된 사용자 이름 가져오기
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

  Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        print("Post deleted successfully: $id");
        fetchPosts(); // 게시글 다시 로드
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
            onPressed: () {
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(username: currentUser!)),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                              Text(
                                "작성자: ${post.author}",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.0,
                                ),
                              ),
                              if (post.author == currentUser)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white30),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("게시글 삭제"),
                                        content: Text("이 게시글을 삭제하시겠습니까?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("취소"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deletePost(post.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("삭제"),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            post.content,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          if (post.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                post.imageUrl!,
                                fit: BoxFit.cover,
                                height: 200, // 이미지 최대 높이 설정
                              ),
                            ),
                          SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreationPage(onPostCreated: (content, imageFile) {
              fetchPosts(); // 새 게시글 생성 후 다시 로드
            })),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
