import 'package:clothes_randomizer_app/themes/system.theme.dart';
import 'package:flutter/material.dart';

ThemeData dark({
  required BuildContext context,
}) =>
    getTheme(
      brightness: Brightness.dark,
      context: context,
      primary: Colors.grey.shade700,
      onPrimary: Colors.white,
      onSurface: Colors.grey.shade500,
      appBar: Colors.grey.shade700,
      appBarShadow: Colors.grey,
      bottomAppBarShadow: Colors.grey,
      canvas: Colors.black,
      card: Colors.grey.shade900,
      dialogBackground: Colors.grey.shade900,
      divider: Colors.grey.shade800,
      listTileIcon: Colors.grey.shade500,
      scaffoldBackground: Colors.black,
      shadow: Colors.grey,
      snackBarBackground: Colors.white,
      snackBarContent: Colors.grey.shade700,
      textBody: Colors.grey.shade500,
      textDisplay: Colors.grey.shade600,
      textButtonForeground: Colors.grey.shade500,
      textFieldLabelBlurred: Colors.grey.shade500,
      textFieldLabelFocused: Colors.grey.shade500,
    );
