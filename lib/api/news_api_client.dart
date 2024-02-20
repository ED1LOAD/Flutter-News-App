import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nisproject/model/article.dart';

class NewsApiClient {
  static const String apiKey = '5c56708e3e1442c4ba1d5e778399c6d0';
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
