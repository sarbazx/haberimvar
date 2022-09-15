import 'dart:convert';

import 'package:flutter/material.dart';
import 'info.dart';
import 'initial_news.dart';
import 'package:http/http.dart' as http;

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  List<InitialNews> news = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialNews();
  }

  List<InitialNews> _parseInitialNews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<InitialNews>(
          (json) => InitialNews.fromJson(json),
        )
        .toList();
  }

  void _fetchInitialNews() async {
    try {
      final url = Uri.http(apiUrl, '/initial');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          news = _parseInitialNews(response.body);
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HaberimVar'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () {
            return Future.sync(
              () {
                _fetchInitialNews();
              },
            );
          },
          child: ListView.builder(
            itemCount: news.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    ctx,
                    '/news',
                    arguments: news[index].id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(news[index].title),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
