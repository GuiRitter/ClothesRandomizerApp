import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeOptionWidget extends StatelessWidget {
  final ThemeMode themeMode;
  final String title;

  const ThemeOptionWidget({
    super.key,
    required this.themeMode,
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final checked = MyApp.themeNotifier.value == themeMode;

    return ListTile(
      onTap: () => onThemeTapped(
        context: context,
        themeMode: themeMode,
      ),
      title: Text(
        title,
      ),
      trailing: Icon(
        checked ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      ),
    );
  }

  onThemeTapped({
    required BuildContext context,
    required ThemeMode themeMode,
  }) {
    MyApp.themeNotifier.value = themeMode;

    SharedPreferences.getInstance().then(
      (
        prefs,
      ) {
        prefs.setString(
          Settings.theme,
          themeMode.name,
        );
      },
    );

    Navigator.pop(
      context,
    );
  }
}
