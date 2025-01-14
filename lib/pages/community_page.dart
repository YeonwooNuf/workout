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

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String baseUrl = "http://10.0.2.2:8080";
    String? imageUrl = json['postImageUrl'] != null
        ? "$baseUrl${json['postImageUrl']}"
        : null;

    print("Decoded post: id=${json['postId']}, imageUrl=$imageUrl"); // 디버깅 로그 추가

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
  final String currentUser = "1"; // 테스트 사용자 ID
  final String baseUrl = "http://10.0.2.2:8080/api/posts";

  @override
  void initState() {
    super.initState();
    fetchPosts(); // 게시글 로드
  }

  Future<void> fetchPosts() async {
    final String url = "$baseUrl/$currentUser";
    try {
      final response = await http.get(Uri.parse(url));
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

  Future<void> createPost(String content, File? imageFile) async {
    final String url = "$baseUrl/$currentUser";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['content'] = content;
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        setState(() {
          posts.add(Post.fromJson(jsonResponse));
        });
      } else {
        print("Failed to create post: ${response.statusCode}");
        print("Response: ${await response.stream.bytesToString()}");
      }
    } catch (e) {
      print("Error creating post: $e");
    }
  }

  Future<void> deletePost(int id) async {
    final String url = "$baseUrl/$id";
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          posts.removeWhere((post) => post.id == id);
        });
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
      MaterialPageRoute(
        builder: (context) => PostCreationPage(
          onPostCreated: (content, imageFile) {
            createPost(content, imageFile);
          },
        ),
      ),
    );
  }

  void openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(username: currentUser),
      ),
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
              onPressed: () {
                deletePost(post.id);
              },
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