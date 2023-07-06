import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoadingBloc with ChangeNotifier {
  bool _isLoading = false;
  CancelToken? _cancelToken;

  bool get isLoading => _isLoading;

  cancelRequest() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  hide({
    required bool isNotify,
  }) {
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
    _isLoading = true;
    _cancelToken = cancelToken;
    if (isNotify) {
      notifyListeners();
    }
  }
}
