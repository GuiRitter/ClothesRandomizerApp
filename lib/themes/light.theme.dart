import 'package:flutter/material.dart';

ThemeData light({
  required BuildContext context,
}) =>
    ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          const Color(
            0xFF90c2d7,
            // 0xFFe7f7eb,
            // 0xFF006a2a,
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
