import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

class CustomDio extends DioForBrowser {
  CustomDio() {
    options.baseUrl = Settings.apiUrl;
    options.contentType = Headers.formUrlEncodedContentType;
  }
}
