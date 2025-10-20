import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostFormScreen(),
    );
  }
}

class PostFormScreen extends StatefulWidget {
  @override
  State<PostFormScreen> createState() => PostFormScreenState();
}

class PostFormScreenState extends State<PostFormScreen> {
  var titleController = TextEditingController();
  var bodyController = TextEditingController();

  void submitPost() async {
    var url = Uri.parse('https://reqres.in/api/posts');
    var res = await http.post(url, body: {
      'title': titleController.text,
      'body': bodyController.text,
    });
    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitPost,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
