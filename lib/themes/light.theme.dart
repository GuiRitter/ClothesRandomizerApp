import 'package:clothes_randomizer_app/themes/system.theme.dart';
import 'package:flutter/material.dart';

class IndigoDye {
  static const raw = Color.fromARGB(
    255,
    0,
    65,
    106,
  );

  /// Foreground: onPrimary
  /// Background: this
  /// Contrast Ratio: >= 7
  static const primary = Color.fromARGB(
    255,
    179,
    223,
    255,
  );

  /// Foreground: this
  /// Background: scaffoldBackground
  /// Contrast Ratio: >= 7
  static const body = Color.fromARGB(
    255,
    0,
    89,
    153,
  );

  /// Foreground: textBody
  /// Background: this
  /// Contrast Ratio: <= 4.5
  static const selection = Color.fromARGB(
    255,
    61,
    181,
    255,
  );
}

class Buff {
  static const raw = Color.fromARGB(
    255,
    218,
    160,
    109,
  );

  /// Foreground: this
  /// Background: scaffoldBackground
  /// Contrast Ratio: >= 7
  static const body = Color.fromARGB(
    255,
    135,
    72,
    34,
  );
}

ThemeData light({
  required BuildContext context,
}) {
  final theme = Theme.of(
    context,
  );

  return getTheme(
    brightness: Brightness.light,
    context: context,
    secondary: Buff.body,
    appBarBackground: IndigoDye.primary,
    appBarForeground: Colors.grey.shade800,
    cardBackground: Colors.grey.shade300,
    dialogBackground: Colors.white,
    divider: Colors.grey.shade400,
    elevatedButtonBackground: IndigoDye.primary,
    elevatedButtonForeground: Colors.grey.shade800,
    elevatedButtonDisabledBackground: Colors.grey.shade400,
    elevatedButtonDisabledForeground: Colors.grey.shade600,
    hover: Colors.black12,
    listTileIconForeground: Colors.grey.shade800,
    popupMenuBackground: Color.lerp(
      Colors.white,
      IndigoDye.selection,
      0.05,
    )!,
    progressIndicator: IndigoDye.body,
    scaffoldBackground: Colors.white,
    scrim: Colors.white.withAlpha(
      192,
    ),
    scrollBarColor: Colors.grey.shade600,
    scrollBarOverlay: Colors.black,
    shadow: theme.shadowColor,
    snackBarBackground: Colors.black,
    snackBarForeground: Colors.grey.shade500,
    splash: Colors.black.withAlpha(
      32,
    ),
    textBody: Colors.grey.shade800,
    textCursor: IndigoDye.body,
    textDisplay: Colors.grey.shade600,
    textButtonForeground: IndigoDye.body,
    textButtonOverlay: IndigoDye.primary,
    textFieldBorderBlurred: Colors.grey.shade500,
    textFieldBorderFocused: IndigoDye.body,
    textFieldLabelBlurred: Colors.grey.shade600,
    textFieldLabelFocused: IndigoDye.body,
    textSelectionBackground: IndigoDye.selection,
    textSelectionHandle: Buff.body,
  );
}
