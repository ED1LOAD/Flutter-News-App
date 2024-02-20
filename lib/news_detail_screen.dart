// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nisproject/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(article.urlToImage),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[200],
                foregroundColor: Colors.red[800],
              ),
              child: Text('news_browser'.tr()),
              onPressed: () async {
                final url = Uri.parse(article.url);
                if (await canLaunchUrl(url)) {
                  try {
                    await launchUrl(url);
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Failed to open the article.')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Could not launch ${article.url}')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
