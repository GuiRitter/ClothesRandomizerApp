import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/api_url.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/models/sign_in.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String? _token;

  final _api = Settings.api;

  String? get token => _token;

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

  Future<Result> signIn(
    SignInModel signInModel,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      Settings.token,
      "",
    );

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    final result = await _api.postResult(
      ApiUrl.signIn.path,
      data: signInModel.toJson(),
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: true,
    );

    if (result.status == ResultStatus.success) {
      _token = result.data[Settings.data][Settings.token];

      prefs.setString(
        Settings.token,
        _token!,
      );

      _api.options.headers[Settings.token] = _token;

      notifyListeners();
    }

    return result;
  }

  Future<Result<String?>> validateAndSetToken({
    String? newToken,
    bool revalidate = false,
  }) async {
    if (revalidate) {
      newToken = _token;
    } else if (_token == newToken) {
      return Result.success();
    }

    if (newToken == null) {
      await clearToken();
      notifyListeners();
      return Result.success();
    }

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    _api.options.headers[Settings.token] = newToken;

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    final response = await _api.getResult(
      ApiUrl.checkToken.path,
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    Result<String?> result = response.withData(
      handler: (
        data,
      ) =>
          (response.status == ResultStatus.success) ? data.toString() : null,
    );

    if (response.status != ResultStatus.unauthorized) {
      _token = newToken;
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return result;
  }
}
