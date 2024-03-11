import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nisproject/BLoC/favoritesEvent.dart';
import 'package:nisproject/BLoC/favoritesState.dart';
import 'package:nisproject/Data/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> favoritesJsonList =
          prefs.getStringList('favorites') ?? [];
      final favorites = favoritesJsonList
          .map((json) => Article.fromJson(jsonDecode(json)))
          .toList();
      emit(FavoritesLoaded(favorites));
    } catch (error) {
      emit(FavoritesError("Failed to load favorites"));
    }
  }

  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoritesState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      if (!currentState.favorites
          .any((element) => element.url == event.article.url)) {
        final updatedFavorites = List<Article>.from(currentState.favorites)
          ..add(event.article);
        _saveToFavorites(updatedFavorites);
        emit(FavoritesLoaded(updatedFavorites));
      }
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoritesState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final updatedFavorites = currentState.favorites
          .where((article) => article.url != event.article.url)
          .toList();
      _saveToFavorites(updatedFavorites);
      emit(FavoritesLoaded(updatedFavorites));
    }
  }

  void _saveToFavorites(List<Article> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJsonList =
        favorites.map((article) => jsonEncode(article.toJson())).toList();
    await prefs.setStringList('favorites', favoritesJsonList);
  }
}
