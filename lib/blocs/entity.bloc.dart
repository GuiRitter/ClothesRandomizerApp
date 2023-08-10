import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/entity.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _log = logger("EntityBloc");

class EntityBloc extends ChangeNotifier {
  final _api = Settings.api;

  EntityModel? _entity;

  final List<Map<String, dynamic>> _entityList = [];

  EntityModel? get entity => _entity;

  List<Map<String, dynamic>> get entityList => List.unmodifiable(
        _entityList,
      );

  exit() {
    _log("exit").enum_("entity", _entity).print();

    _entity = null;
    _entityList.clear();
    notifyListeners();
  }

  manageEntity({
    required EntityModel entityModel,
  }) async {
    _log("manageEntity").enum_("entity", _entity).print();

    _entity = entityModel;

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    var response = await _api.getResult(
      entityModel.listUrl.path,
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    _populateEntityList(
      entityModel: _entity!,
      data: (response.status == ResultStatus.success) ? response.data : [],
    );

    notifyListeners();
  }

  _populateEntityList({
    required EntityModel entityModel,
    required data,
  }) {
    _log("_populateBaseData")
        .enum_("entity", _entity)
        .raw("data", data)
        .print();

    _entityList.clear();

    for (final local in data) {
      final entity = <String, dynamic>{};

      // forEach removed because of avoid_function_literals_in_foreach_calls
      for (final column in entityModel.columnList) {
        entity[column] = local[column];
      }

      _entityList.add(
        entity,
      );
    }
  }
}
