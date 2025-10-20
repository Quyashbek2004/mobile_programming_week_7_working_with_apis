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
      home: CurrencyScreen(),
    );
  }
}

class CurrencyScreen extends StatefulWidget {
  @override
  State<CurrencyScreen> createState() => CurrencyScreenState();
}

class CurrencyScreenState extends State<CurrencyScreen> {
  var dateController = TextEditingController();
  var codeController = TextEditingController();
  var data = [];
  var loading = false;

  void fetchRates() async {
    setState(() {
      loading = true;
      data = [];
    });

    String date = dateController.text.trim();
    String code = codeController.text.trim().toUpperCase();

    String url;
    if (date.isEmpty && code.isEmpty) {
      url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/';
    } else if (code.isEmpty || code == 'ALL') {
      url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/all/$date/';
    } else {
      url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/$code/$date/';
    }

    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      if (decoded is List) {
        data = decoded;
      } else {
        data = [decoded];
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Rates (CBU)')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Enter date (YYYY-MM-DD)',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter currency code (USD, RUB, ALL)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchRates,
              child: Text('Fetch Rates'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : data.isEmpty
                  ? Center(child: Text('No data'))
                  : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  var item = data[i];
                  return ListTile(
                    title: Text(item['CcyNm_UZ'] ?? ''),
                    subtitle: Text('Code: ${item['Ccy']} | Rate: ${item['Rate']} UZS'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
