import 'package:flutter/material.dart';

ThemeData dark({
  required BuildContext context,
}) =>
    ThemeData.dark(
      useMaterial3: false,
    ).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          const Color(
            0xFF105d89,
          ).value,
          const {
            50: Color(
              0xFFe3f0f4,
            ),
            100: Color(
              0xFFb9d9e6,
            ),
            200: Color(
              0xFF90c2d7,
            ),
            300: Color(
              0xFF6aaac7,
            ),
            400: Color(
              0xFF4f99be,
            ),
            500: Color(
              0xFF358ab5,
            ),
            600: Color(
              0xFF287daa,
            ),
            700: Color(
              0xFF1b6d9a,
            ),
            800: Color(
              0xFF105d89,
            ),
            900: Color(
              0xFF00416a,
            ),
          },
        ),
        accentColor: const Color.fromARGB(
          255,
          218,
          160,
          106,
        ),
        backgroundColor: const Color(
          0xFF121212,
        ),
        brightness: Brightness.dark,
        cardColor: const Color(
          0xFF121212,
        ),
        errorColor: const Color(
          0xFFCF6679,
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(
          0xFF105d89,
        ),
      ),
    );
