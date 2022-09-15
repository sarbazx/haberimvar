import 'dart:convert';

import 'package:flutter/material.dart';
import 'info.dart';
import 'news.dart';
import 'recommender.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.id});
  final int id;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  News news = News.empty;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  News _parseNews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<News>(
          (json) => News.fromJson(json),
        )
        .toList()[0];
  }

  void _fetchNews() async {
    try {
      final url = Uri.http(apiUrl, '/${widget.id}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          news = _parseNews(response.body);
        });
      }
    } catch (_) {}
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HaberimVar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  news.content,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _launchUrl(news.url);
                  },
                  child: const Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Recommender(
                    title: news.title,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
