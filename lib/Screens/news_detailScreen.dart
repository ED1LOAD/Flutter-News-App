import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nisproject/BLoC/favoritesEvent.dart';
import 'package:nisproject/BLoC/favoritesState.dart';
import 'package:nisproject/Data/favorite_news.dart';
import 'package:nisproject/Data/news_article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded &&
            state.favorites.any((a) => a.url == article.url);
        return Scaffold(
          appBar: AppBar(
            title:
                Text(article.title.isEmpty ? 'No Title'.tr() : article.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => isFavorite
                    ? context.read<FavoritesBloc>().add(RemoveFavorite(article))
                    : context.read<FavoritesBloc>().add(AddFavorite(article)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                article.urlToImage.isNotEmpty
                    ? Image.network(
                        article.urlToImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/placeholder.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/placeholder.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    article.description.isNotEmpty
                        ? article.description
                        : 'No Description'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    article.content.isNotEmpty
                        ? article.content
                        : 'No Content'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${'Author'.tr()}: ${article.author}, ${'Published At'.tr()}: ${DateFormat('yyyy-MM-dd, kk:mm').format(DateTime.parse(article.publishedAt))}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[200],
                        foregroundColor: Colors.red[800],
                      ),
                      child: Text('news_browser'.tr()),
                      onPressed: () => _launchURL(article.url, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    if (url.isNotEmpty) {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch ${article.url}'.tr())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid URL'.tr())));
    }
  }
}
