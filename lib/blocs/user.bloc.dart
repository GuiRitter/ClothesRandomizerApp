import 'dart:io';

import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/api_url.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/models/sign_in.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String? _token;
  final LoadingBloc loadingBloc;

  final _api = Settings.api;

  UserBloc({
    required this.loadingBloc,
  });

  String? get token => _token;

  Future<void> signIn(
    SignInModel signInModel,
  ) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(
        Settings.token,
        "",
      );

      final cancelToken = CancelToken();
      loadingBloc.show(
        cancelToken: cancelToken,
        isNotify: true,
      );

      final response = await _api.post(
        ApiUrl.signIn.path,
        data: signInModel.toJson(),
        cancelToken: cancelToken,
      );

      loadingBloc.hide(
        isNotify: true,
      );

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
      loadingBloc.hide(
        isNotify: true,
      );
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
      await clearToken();
      notifyListeners();
      return Result(
        status: ResultStatus.success,
      );
    }

    _api.options.headers[Settings.token] = newToken;

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    var response = await _validateToken(
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    // TODO interceptor?
    if (response.status == ResultStatus.unauthorized) {
      await clearToken();
    } else {
      _token = newToken;
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return response;
  }

  clearToken() async {
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
