import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'posting_page.dart';
import 'profile_page.dart';

class Post {
  final int id;
  final String author;
  final String content;
  final String? imageUrl;

  Post({required this.id, required this.author, required this.content, this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['postImageUrl'] != null ? "http://10.0.2.2:8080${json['postImageUrl']}" : null;
    print("Post image URL: $imageUrl"); // 디버깅 로그 추가
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
  final String currentUser = "current_user"; // 현재 사용자 이름
  final String apiUrl = "http://10.0.2.2:8080/api/posts"; // API URL

  @override
  void initState() {
    super.initState();
    fetchPosts(); // 게시글 로드
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/posts"));
      if (response.statusCode == 200) {
        setState(() {
          posts = (json.decode(response.body) as List)
              .map((data) => Post.fromJson(data))
              .toList();
        });
        print("Fetched posts: $posts");
      } else {
        print("Failed to fetch posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> createPost(String content, File? imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://10.0.2.2:8080/api/posts/1")); // 1은 테스트용 userId
      request.fields['content'] = content;
      if (imageFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.path));
      }
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Post created successfully");
        fetchPosts();
      } else {
        print("Failed to create post: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating post: $e");
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

  void openPostCreationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostCreationPage(onPostCreated: (content, imageFile) {
        createPost(content, imageFile);
      })),
    );
  }

  void openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(username: currentUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("커뮤니티"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: openProfilePage,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.imageUrl != null)
                  Image.network(post.imageUrl!),
                Text(post.content),
              ],
            ),
            subtitle: Text("작성자: ${post.author}"),
            trailing: post.author == currentUser
                ? IconButton(
              icon: Icon(Icons.delete),
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
            )
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openPostCreationPage,
        child: Icon(Icons.add),
      ),
    );
  }
}
