import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'info.dart';
import 'recommend.dart';

class Recommender extends StatefulWidget {
  const Recommender({super.key, required this.title});

  final String title;

  @override
  State<Recommender> createState() => _RecommenderState();
}

class _RecommenderState extends State<Recommender> {
  List<Recommend> news = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommend();
  }

  List<Recommend> _parseRecommend(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return parsed['data']
        .map<Recommend>(
          (json) => Recommend.fromJson(json),
        )
        .toList();
  }

  void _fetchRecommend() async {
    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.http(apiUrl, '/recommended');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': widget.title,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          news = _parseRecommend(response.body);
          isLoading = false;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () {
        return Future.sync(
          () {
            _fetchRecommend();
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
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(news[index].title),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
