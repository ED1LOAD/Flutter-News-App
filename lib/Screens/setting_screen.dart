import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nisproject/Screens/news_listScreen.dart';
import 'package:nisproject/Theme/theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.getTheme() == ThemeData.light();

    return Scaffold(
      body: ListView(
        children: <Widget>[
          ThemeSwitchListTile(
              isLightTheme: isLightTheme, themeProvider: themeProvider),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'change_language'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LanguageButton(
                  languageCode: 'en',
                  isSelected: context.locale.languageCode == 'en',
                ),
                LanguageButton(
                  languageCode: 'ru',
                  isSelected: context.locale.languageCode == 'ru',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeSwitchListTile extends StatelessWidget {
  final bool isLightTheme;
  final ThemeProvider themeProvider;

  const ThemeSwitchListTile({
    Key? key,
    required this.isLightTheme,
    required this.themeProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        isLightTheme ? 'light_theme'.tr() : 'dark_theme'.tr(),
        style: const TextStyle(fontSize: 20),
      ),
      trailing: Switch(
        activeColor: Colors.red,
        value: isLightTheme,
        onChanged: (value) {
          themeProvider.setTheme(value ? ThemeData.light() : ThemeData.dark());
        },
      ),
      leading: Icon(
        isLightTheme ? Icons.light_mode : Icons.dark_mode,
        size: 30,
      ),
      onTap: () {
        themeProvider
            .setTheme(isLightTheme ? ThemeData.dark() : ThemeData.light());
      },
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String languageCode;
  final bool isSelected;

  const LanguageButton({
    Key? key,
    required this.languageCode,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.setLocale(Locale(languageCode)).then((_) {
          final state = context.findAncestorStateOfType<NewsListScreenState>();
          // ignore: invalid_use_of_protected_member
          state?.setState(() {});
        });
      },
      child: CircleAvatar(
        backgroundColor: isSelected ? Colors.red : Colors.grey,
        child: Text(
          languageCode.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
