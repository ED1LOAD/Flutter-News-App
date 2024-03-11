import 'package:nisproject/Data/news_article.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final Article article;

  AddFavorite(this.article);
}

class RemoveFavorite extends FavoritesEvent {
  final Article article;

  RemoveFavorite(this.article);
}
