import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nisproject/BLoC/favoritesEvent.dart';
import 'package:nisproject/Data/favorite_news.dart';
import 'package:nisproject/Screens/news_listScreen.dart';

import 'package:nisproject/Theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/lang',
      fallbackLocale: const Locale('ru'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ThemeProvider(ThemeData.light())),
        ],
        child: BlocProvider(
          create: (context) => FavoritesBloc()..add(LoadFavorites()),
          child: const NewsApp(),
        ),
      ),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const NewsListScreen(),
    );
  }
}
