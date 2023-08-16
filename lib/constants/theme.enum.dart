import 'package:flutter/material.dart';

enum ThemeEnum {
  dark(
    mode: ThemeMode.dark,
    isTest: false,
  ),
  light(
    mode: ThemeMode.light,
    isTest: false,
  ),
  system(
    mode: ThemeMode.system,
    isTest: false,
  ),
  testDark(
    mode: ThemeMode.dark,
    isTest: true,
  ),
  testLight(
    mode: ThemeMode.light,
    isTest: true,
  );

  final ThemeMode mode;
  final bool isTest;

  const ThemeEnum({
    required this.mode,
    required this.isTest,
  });

  ThemeEnum get notTest => ThemeEnum.values.byName(
        mode.name,
      );
}
