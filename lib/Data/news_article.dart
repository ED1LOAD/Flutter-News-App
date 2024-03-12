class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String url;
  final String author;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
    required this.author,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      content: json['content'] ?? 'No Content',
      url: json['url'],
      author: json['author'] ?? 'Unknown Author',
      publishedAt: json['publishedAt'] ?? 'Unknown Date',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'url': url,
      'author': author,
      'publishedAt': publishedAt,
    };
  }
}
