import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nisproject/BLoC/favoritesState.dart';
import 'package:nisproject/Data/favorite_news.dart';

import 'news_detailScreen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesLoaded) {
          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (BuildContext context, int index) {
              final article = state.favorites[index];
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
        } else if (state is FavoritesError) {
          return Center(child: Text('error_loading_favorites'.tr()));
        } else {
          return Center(child: Text('unknown_state'.tr()));
        }
      },
    );
  }
}
