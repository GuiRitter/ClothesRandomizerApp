import 'package:flutter/material.dart';

ThemeData light({
  required BuildContext context,
}) =>
    ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          const Color(
            0xFF50C878,
            // 0xFFe7f7eb,
            // 0xFF006a2a,
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
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        cardColor: Colors.white,
        errorColor: const Color(
          0xFFB00020,
        ),
      ),
    );
