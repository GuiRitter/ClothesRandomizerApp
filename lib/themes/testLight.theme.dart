import 'package:clothes_randomizer_app/themes/system.theme.dart';
import 'package:flutter/material.dart';

ThemeData testLight({
  required BuildContext context,
}) =>
    getTheme(
      brightness: Brightness.light,
      context: context,
      primary: Colors.green,
      onPrimary: Colors.purple,
      onSurface: Colors.deepOrange,
      appBar: Colors.green,
      appBarShadow: Colors.red,
      bottomAppBarShadow: Colors.red,
      canvas: Colors.blue.shade900,
      card: Colors.brown,
      dialogBackground: Colors.deepPurple,
      divider: Colors.pink,
      listTileIcon: Colors.yellow,
      scaffoldBackground: Colors.blue.shade900,
      shadow: Colors.red,
      snackBarBackground: Colors.red,
      snackBarContent: Colors.blue,
      textBody: Colors.yellow,
      textDisplay: Colors.yellow,
      textButtonForeground: Colors.yellow,
      textFieldLabelBlurred: Colors.yellow,
      textFieldLabelFocused: Colors.green,
    );
