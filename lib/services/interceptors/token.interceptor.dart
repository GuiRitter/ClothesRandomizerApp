import 'dart:io';

import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class TokenInterceptor extends InterceptorsWrapper {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final userBloc = Provider.of<UserBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    if (err.response?.statusCode == HttpStatus.unauthorized) {
      await userBloc.clearToken();
    }

    if (err.response != null) {
      handler.resolve(
        err.response!,
      );
    } else {
      handler.next(
        err,
      );
    }
  }
}
