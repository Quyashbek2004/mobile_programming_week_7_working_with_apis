import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var posts = [];
  var isLoading = true;

  void loadData() async {
    var res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    posts = jsonDecode(res.body);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Posts')),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(posts[i]['title']),
            );
          },
        ),
      ),
    );
  }
}
