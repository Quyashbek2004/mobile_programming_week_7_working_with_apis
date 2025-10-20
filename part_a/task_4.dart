import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List posts = []; // List to hold post data
  bool isLoading = true; // To show loading indicator

  // Function to fetch and decode posts
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body); // Decode JSON into a List
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Fetch data when app starts
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('All Post Titles'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator()) // Show spinner while loading
            : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(posts[index]['id'].toString()),
              ),
              title: Text(posts[index]['title']),
              subtitle: Text('User ID: ${posts[index]['userId']}'),
            );
          },
        ),
      ),
    );
  }
}
