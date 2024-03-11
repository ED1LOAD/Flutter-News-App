import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nisproject/Data/news_article.dart';

class NewsApiClient {
  static const String apiKey = 'd22d857cdac84522b5b8e3ec533ff060';
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String headlinesEndpoint =
      '/top-headlines?country=us&apiKey=$apiKey';

  static Future<List<Article>> fetchArticles({int page = 1}) async {
    final String url = '$baseUrl$headlinesEndpoint&page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result['articles'];
      return list.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
