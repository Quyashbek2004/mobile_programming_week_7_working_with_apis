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
  var isError = false;

  void loadData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    var res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (res.statusCode == 200) {
      posts = jsonDecode(res.body);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
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
            : isError
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading data!'),
              SizedBox(height: 10),
              ElevatedButton(onPressed: loadData, child: Text('Retry')),
            ],
          ),
        )
            : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(posts[i]['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      title: posts[i]['title'],
                      body: posts[i]['body'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  final String body;

  const DetailScreen({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(body, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
