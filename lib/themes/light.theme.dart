import 'package:clothes_randomizer_app/themes/system.theme.dart';
import 'package:flutter/material.dart';

ThemeData light({
  required BuildContext context,
}) =>
    getTheme(
      brightness: Brightness.light,
      context: context,
      primary: Colors.grey.shade500,
      onPrimary: Colors.black,
      onSurface: Colors.grey.shade800,
      appBar: Colors.grey.shade500,
      appBarShadow: Theme.of(
        context,
      ).shadowColor,
      bottomAppBarShadow: Colors.grey,
      canvas: Colors.white,
      card: Colors.grey.shade300,
      dialogBackground: Colors.grey.shade300,
      divider: Colors.grey.shade400,
      listTileIcon: Colors.grey.shade500,
      scaffoldBackground: Colors.white,
      scrim: Colors.black54,
      shadow: Theme.of(
        context,
      ).shadowColor,
      snackBarBackground: Colors.black,
      snackBarContent: Colors.grey.shade500,
      textBody: Colors.grey.shade800,
      textDisplay: Colors.grey.shade600,
      textButtonForeground: Colors.grey.shade800,
      textFieldLabelBlurred: Colors.grey.shade800,
      textFieldLabelFocused: Colors.grey.shade800,
    );
