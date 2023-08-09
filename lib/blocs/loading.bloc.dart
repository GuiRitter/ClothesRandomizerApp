import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final _log = logger("LoadingBloc");

class LoadingBloc with ChangeNotifier {
  bool _isLoading = false;
  CancelToken? _cancelToken;

  bool get isLoading => _isLoading;

  cancelRequest() {
    _log("hide").print();

    _cancelToken?.cancel();
    _cancelToken = null;
  }

  hide({
    required bool isNotify,
  }) {
    _log("hide").raw("isNotify", isNotify).print();

    _isLoading = false;
    _cancelToken = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  show({
    required CancelToken cancelToken,
    required bool isNotify,
  }) {
    _log("show").raw("isNotify", isNotify).print();

    _isLoading = true;
    _cancelToken = cancelToken;
    if (isNotify) {
      notifyListeners();
    }
  }
}
