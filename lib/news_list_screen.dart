// ignore_for_file: empty_catches, unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nisproject/api/news_api_client.dart';
import 'package:nisproject/model/article.dart';
import 'package:nisproject/news_detail_screen.dart';
import 'settings_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  NewsListScreenState createState() => NewsListScreenState();
}

class NewsListScreenState extends State<NewsListScreen> {
  int selectedIndex = 0;
  late Future<List<Article>> articles;
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    articles = fetchArticles();
  }

  Future<List<Article>> fetchArticles() async {
    return NewsApiClient.fetchArticles(page: currentPage);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void loadMoreArticles() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Article> newArticles =
          await NewsApiClient.fetchArticles(page: currentPage + 1);
      setState(() {
        currentPage++;
        articles = Future.value([...articles as List<Article>, ...newArticles]);
      });
    } catch (error) {}

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      FutureBuilder<List<Article>>(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found'));
          } else {
            final articles = snapshot.data!
                .where((article) =>
                    article.title.isNotEmpty && article.urlToImage.isNotEmpty)
                .toList();
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data!.length) {
                  loadMoreArticles();
                  return const Center(child: CircularProgressIndicator());
                }
                final article = snapshot.data![index];
                return Column(
                  children: <Widget>[
                    // ignore: unnecessary_null_comparison
                    article.urlToImage != null
                        ? Image.network(
                            article.urlToImage,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/placeholder.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                    ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            selectedIndex == 0 ? 'news_title'.tr() : 'settings_title'.tr()),
      ),
      body: screens.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.newspaper),
            label: 'news_tapbar'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.gear),
            label: 'settings_tapbar'.tr(),
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        onTap: onItemTapped,
      ),
    );
  }
}
