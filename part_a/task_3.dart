import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Function to send a GET request
  Future<void> fetchPosts() async {


    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      var data=jsonDecode(response.body);

      print('Status code: ${response.statusCode}');
      print('First post title ${data[0]['title']}');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call fetchPosts when the app starts
    fetchPosts();

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Check console for GET response!'),
        ),
      ),
    );
  }
}
