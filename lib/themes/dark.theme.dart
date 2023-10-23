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
    0,
    91,
    148,
  );

  /// Foreground: this
  /// Background: scaffoldBackground
  /// Contrast Ratio: >= 7
  static const body = Color.fromARGB(
    255,
    10,
    153,
    255,
  );

  /// Foreground: textBody
  /// Background: this
  /// Contrast Ratio: <= 4.5
  static const selection = Color.fromARGB(
    255,
    0,
    57,
    92,
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
    208,
    133,
    67,
  );
}

ThemeData dark({
  required BuildContext context,
}) =>
    getTheme(
      brightness: Brightness.dark,
      context: context,
      secondary: Buff.body,
      appBarBackground: IndigoDye.primary,
      appBarForeground: Colors.white,
      cardBackground: Colors.grey.shade900,
      dialogBackground: Colors.black,
      divider: Colors.grey.shade800,
      elevatedButtonBackground: IndigoDye.primary,
      elevatedButtonForeground: Colors.white,
      elevatedButtonDisabledBackground: Colors.grey.shade800,
      elevatedButtonDisabledForeground: Colors.grey.shade600,
      hover: Colors.white10,
      listTileIconForeground: Colors.grey.shade500,
      popupMenuBackground: Color.lerp(
        Colors.black,
        IndigoDye.selection,
        0.25,
      )!,
      progressIndicator: IndigoDye.body,
      scaffoldBackground: Colors.black,
      scrim: Colors.black.withAlpha(
        192,
      ),
      scrollBarColor: Colors.grey.shade600,
      scrollBarOverlay: Colors.white,
      shadow: Colors.grey,
      snackBarBackground: Colors.white,
      snackBarForeground: Colors.grey.shade700,
      splash: Colors.white.withAlpha(
        32,
      ),
      textBody: Colors.grey.shade500,
      textCursor: IndigoDye.body,
      textDisplay: Colors.grey.shade600,
      textButtonForeground: IndigoDye.body,
      textButtonOverlay: IndigoDye.primary,
      textFieldBorderBlurred: Colors.grey.shade700,
      textFieldBorderFocused: IndigoDye.body,
      textFieldLabelBlurred: Colors.grey.shade600,
      textFieldLabelFocused: IndigoDye.body,
      textSelectionBackground: IndigoDye.selection,
      textSelectionHandle: Buff.body,
    );
