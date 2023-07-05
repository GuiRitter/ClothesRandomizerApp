import 'dart:io';

import 'package:clothes_randomizer_app/constants/api_url.dart';
import 'package:clothes_randomizer_app/constants/result_status.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/models/sign_in.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String? _token;
  bool isLoading = false;
  CancelToken? _cancelToken;

  final _api = Settings.api;

  String? get token => _token;

  cancelRequest() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  Future<void> signIn(
    SignInModel signInModel,
  ) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(
        Settings.token,
        "",
      );

      isLoading = true;
      _cancelToken = CancelToken();
      notifyListeners();

      final response = await _api.post(
        ApiUrl.signIn.path,
        data: signInModel.toJson(),
        cancelToken: _cancelToken,
      );

      isLoading = false;
      _cancelToken = null;
      notifyListeners();

      if ((response.statusCode != HttpStatus.ok) ||
          (response.data is! Map) ||
          (!(response.data as Map).containsKey(
            Settings.data,
          )) ||
          ((response.data as Map)[Settings.data] is! Map) ||
          (!((response.data as Map)[Settings.data] as Map).containsKey(
            Settings.token,
          ))) {
        throw response;
      }

      _token = response.data[Settings.data][Settings.token];
      prefs.setString(
        Settings.token,
        _token!,
      );
      _api.options.headers[Settings.token] = _token;

      notifyListeners();
    } catch (_) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Result<String?>> validateAndSetToken({
    String? newToken,
    bool revalidate = false,
  }) async {
    if (revalidate) {
      newToken = _token;
    } else if (_token == newToken) {
      return Result(
        status: ResultStatus.success,
      );
    }

    if (newToken == null) {
      await _clearToken();
      notifyListeners();
      return Result(
        status: ResultStatus.success,
      );
    }

    _api.options.headers[Settings.token] = newToken;

    isLoading = true;
    _cancelToken = CancelToken();
    notifyListeners();

    var response = await _validateToken(
      cancelToken: _cancelToken!,
    );

    isLoading = false;
    _cancelToken = null;

    if (response.status == ResultStatus.unauthorized) {
      await _clearToken();
    } else {
      _token = newToken;
    }

    notifyListeners();

    return response;
  }

  _clearToken() async {
    _token = null;

    _api.options.headers.remove(
      Settings.token,
    );

    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      Settings.token,
      "",
    );
  }

  Future<Result<String?>> _validateToken({
    required CancelToken cancelToken,
  }) async {
    try {
      final response = await _api.get(
        ApiUrl.checkToken.path,
        cancelToken: cancelToken,
      );

      return Result(
        status: ResultStatus.success,
        data: response.data.toString(),
      );
    } catch (exception) {
      return Result(
        status: ((exception is DioException) &&
                (exception.response?.statusCode == HttpStatus.unauthorized))
            ? ResultStatus.unauthorized
            : ResultStatus.error,
        message: treatException(
          exception: exception,
        ),
      );
    }
  }
}
