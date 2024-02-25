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
  List<Article> articles = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  Future<void> loadArticles({bool isLoadMore = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      if (!isLoadMore) {
        currentPage = 1;
      }
    });

    try {
      List<Article> fetchedArticles =
          await NewsApiClient.fetchArticles(page: currentPage);
      if (fetchedArticles.isEmpty) {
        hasMore = false;
      } else {
        setState(() {
          if (isLoadMore) {
            articles.addAll(fetchedArticles);
          } else {
            articles = fetchedArticles;
          }
          currentPage++;
        });
      }
    } catch (error) {
      // Handle error state
    } finally {
      setState(() => isLoading = false);
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            selectedIndex == 0 ? 'news_title'.tr() : 'settings_title'.tr()),
      ),
      body: selectedIndex == 0 ? buildNewsList() : const SettingsScreen(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildNewsList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          loadArticles(isLoadMore: true);
        }
        return true;
      },
      child: ListView.builder(
        itemCount: articles.length + (hasMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == articles.length) {
            return hasMore
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.red,
                  ))
                : const SizedBox();
          }
          final article = articles[index];
          return buildArticleItem(article);
        },
      ),
    );
  }

  Widget buildArticleItem(Article article) {
    return Column(
      children: <Widget>[
        Image.network(
          article.urlToImage,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/placeholder.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            );
          },
        ),
        ListTile(
          title: Text(article.title),
          subtitle: Text(article.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(article: article),
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const FaIcon(
            FontAwesomeIcons.newspaper,
          ),
          label: 'news_tapbar'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(
            FontAwesomeIcons.gear,
          ),
          label: 'settings_tapbar'.tr(),
        ),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.red,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
