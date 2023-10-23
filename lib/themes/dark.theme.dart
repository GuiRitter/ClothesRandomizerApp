import 'package:flutter/material.dart';

ThemeData dark({
  required BuildContext context,
}) =>
    ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          const Color(
            0xFF006a2a,
          ).value,
          const {
            50: Color(
              0xFFe7f7eb,
            ),
            100: Color(
              0xFFc4ebcf,
            ),
            200: Color(
              0xFF9edeb0,
            ),
            300: Color(
              0xFF73d290,
            ),
            400: Color(
              0xFF50c878,
            ),
            500: Color(
              0xFF24be60,
            ),
            600: Color(
              0xFF19ae55,
            ),
            700: Color(
              0xFF079b49,
            ),
            800: Color(
              0xFF008a3e,
            ),
            900: Color(
              0xFF006a2a,
            ),
          },
        ),
        accentColor: const Color.fromARGB(
          255,
          128,
          255,
          0,
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
          0xFF006a2a,
        ),
      ),
    );
