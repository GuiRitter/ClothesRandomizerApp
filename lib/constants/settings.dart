import 'package:clothes_randomizer_app/services/custom_dio.dart';
import 'package:flutter/material.dart';

class Settings {
  static CustomDio api = CustomDio();

  static String apiUrl =
      "https://guilherme-alan-ritter.net/clothes_randomizer/api/";

  static String data = "data";

  static String error = "error";

  static final GlobalKey<ScaffoldMessengerState> snackState =
      GlobalKey<ScaffoldMessengerState>();

  static String token = "token";
}
