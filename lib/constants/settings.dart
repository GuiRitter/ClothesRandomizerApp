import 'package:clothes_randomizer_app/services/dio/dio_for_any.interface.dart';
import 'package:flutter/material.dart';

class Settings {
  static DioForAny api = DioForAny();

  static String apiUrl =
      "https://guilherme-alan-ritter.net/clothes_randomizer/api/";

  static String data = "data";

  static String error = "error";

  static final GlobalKey<ScaffoldMessengerState> snackState =
      GlobalKey<ScaffoldMessengerState>();

  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();

  static String token = "token";

  static String theme = "theme";
}
