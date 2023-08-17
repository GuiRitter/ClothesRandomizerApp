import 'package:flutter/material.dart';

final themeByBrightness = {
  Brightness.dark: ThemeData.dark(),
  Brightness.light: ThemeData.light(),
};

ThemeData getTheme({
  required Brightness brightness,
  required BuildContext context,
  required Color primary,
  required Color onPrimary,
  required Color onSurface,
  required Color appBar,
  required Color appBarShadow,
  required Color bottomAppBarShadow,
  required Color canvas,
  required Color card,
  required Color dialogBackground,
  required Color divider,
  required Color listTileIcon,
  required Color scaffoldBackground,
  required Color scrim,
  required Color shadow,
  required Color snackBarBackground,
  required Color snackBarContent,
  required Color textBody,
  required Color textDisplay,
  required Color textButtonForeground,
  required Color textFieldLabelBlurred,
  required Color textFieldLabelFocused,
}) {
  return themeByBrightness[brightness]!.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      onSurface: onSurface,
      scrim: scrim,
    ),
    appBarTheme: AppBarTheme(
      color: appBar,
      shadowColor: appBarShadow,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      shadowColor: bottomAppBarShadow,
    ),
    canvasColor: canvas,
    cardColor: card,
    dialogBackgroundColor: dialogBackground,
    dividerColor: divider,
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(
        // only when focused
        color: textFieldLabelFocused,
      ),
      labelStyle: TextStyle(
        // overrides floatingLabelStyle if not defined
        color: textFieldLabelBlurred,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: listTileIcon,
    ),
    scaffoldBackgroundColor: scaffoldBackground,
    shadowColor: shadow,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackBarBackground,
      contentTextStyle: TextStyle(
        color: snackBarContent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textButtonForeground,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: Theme.of(
      context,
    ).textTheme.apply(
          bodyColor: textBody,
          displayColor: textDisplay,
        ),
  );
}
