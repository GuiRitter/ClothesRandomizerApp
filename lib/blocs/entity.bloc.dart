import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/crud.enum.dart';
import 'package:clothes_randomizer_app/constants/entity.enum.dart';
import 'package:clothes_randomizer_app/constants/entity_column.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/models/entity_column.model.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/utils/data.dart';
import 'package:clothes_randomizer_app/utils/entity.extension.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final columnIsEntitySingle = columnIs(
  EntityColumnKind.entitySingle,
);

final _log = logger("EntityBloc");

bool Function(
  EntityColumnModel,
) columnIs(
  EntityColumnKind type,
) =>
    (
      EntityColumnModel column,
    ) =>
        column.kind == type;

class EntityBloc extends ChangeNotifier {
  final _api = Settings.api;

  EntityModel? _entityTemplate;

  final List<Map<String, dynamic>> _entityList = [];

  final Map<String, List<Map<String, dynamic>>> _entityListMap = {};

  StateCRUD _state = StateCRUD.read;

  Map<String, dynamic> get entity => _entityList.single;

  List<Map<String, dynamic>> get entityList => List.unmodifiable(
        _entityList,
      );

  Map<String, List<Map<String, dynamic>>> get entityListMap => Map.unmodifiable(
        _entityListMap,
      );

  EntityModel? get entityTemplate => _entityTemplate;

  StateCRUD get state => _state;

  Future<Result> createEntity() async {
    _log("createEntity").print();

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    final response = await _api.postResult(
      _entityTemplate!.baseUrl.path,
      cancelToken: cancelToken,
      data: entity,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      manageEntity(
        entityModel: _entityTemplate!,
      );
    } else {
      notifyListeners();
    }

    return response.withoutData();
  }

  Future<Result> deleteCascade({
    required Map<String, dynamic> entityToDelete,
  }) async {
    _log("deleteCascade").raw("entity", entityToDelete).print();

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    final response = await _api.deleteResult(
      _entityTemplate!.baseUrl.path,
      cancelToken: cancelToken,
      data: entityToDelete.asIdOnly(),
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      manageEntity(
        entityModel: _entityTemplate!,
      );
    } else {
      notifyListeners();
    }

    return response.withoutData();
  }

  exit() {
    _log("exit").enum_("entity", _entityTemplate).print();

    _entityTemplate = null;
    _entityList.clear();
    _entityListMap.clear();
    notifyListeners();
  }

  Future<Result> manageEntity({
    required EntityModel entityModel,
  }) async {
    _log("manageEntity").enum_("entity", _entityTemplate).print();

    _entityTemplate = entityModel;
    _state = StateCRUD.read;
    _entityListMap.clear();

    final response = await readEntity(
      entityModel: entityModel,
      entityList: _entityList,
    );

    if (response.status == ResultStatus.success) {
      notifyListeners();
    } else {
      exit();
    }

    return response.withoutData();
  }

  Future<Result> readEntity({
    required EntityModel entityModel,
    required List<Map<String, dynamic>> entityList,
  }) async {
    _log("readEntity")
        .enum_("entity", _entityTemplate)
        .existsList("entityList", entityList)
        .print();

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    final cancelToken = CancelToken();
    loadingBloc.show(
      cancelToken: cancelToken,
      isNotify: true,
    );

    final response = await _api.getResult(
      entityModel.listUrl.path,
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      _populateEntityList(
        entityModel: entityModel,
        data: response.data,
        entityList: entityList,
      );
    }

    return response.withoutData();
  }

  void setColumnValue({
    required EntityColumnModel column,
    String? value,
    String? id,
    required bool isNotify,
  }) {
    _log("setColumnValue")
        .map("column", column)
        .raw("value", value)
        .raw("id", id)
        .raw("isNotify", isNotify)
        .print();

    entity[column.name] = value;

    if (column.kind == EntityColumnKind.entitySingle) {
      entity[column.nameId] = id;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  writeEntity({
    required String? id,
  }) async {
    _log("writeEntity").raw("id", id).print();

    _entityList.removeWhere(
      (
        element,
      ) =>
          element[identityColumn] != id,
    );

    _state = (id?.isEmpty ?? true) ? StateCRUD.create : StateCRUD.update;

    if (_state == StateCRUD.create) {
      _entityList.add({});
    }

    _entityListMap.clear();

    for (final feColumn in _entityTemplate!.columnList.where(
      columnIsEntitySingle,
    )) {
      final columnEntityList = getFromMapConstructIfNull(
        map: _entityListMap,
        key: feColumn.type,
        constructor: () => <Map<String, dynamic>>[],
      );

      final columnModel = EntityModel.getModelByName(
        feColumn.type,
      );

      await readEntity(
        entityModel: columnModel,
        entityList: columnEntityList,
      );
    }

    notifyListeners();
  }

  _populateEntityList({
    required EntityModel entityModel,
    required data,
    required List<Map<String, dynamic>> entityList,
  }) {
    _log("_populateEntityList")
        .enum_("entityModel", entityModel)
        .raw("data", data)
        .existsList("entityList", entityList)
        .print();

    entityList.clear();

    for (final dto in data) {
      final entity = <String, dynamic>{};

      // forEach removed because of avoid_function_literals_in_foreach_calls
      for (final column in entityModel.columnList) {
        entity[column.name] = dto[column.name];
      }

      entity[hasDependencyColumn] = dto[hasDependencyColumn];

      entityList.add(
        entity,
      );
    }
  }
}
