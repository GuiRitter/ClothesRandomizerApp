import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/api_url.enum.dart';
import 'package:clothes_randomizer_app/constants/models.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/models/type_use.model.dart';
import 'package:clothes_randomizer_app/models/use.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataBloc extends ChangeNotifier {
  final _api = Settings.api;

  final List<LocalModel> _localList = <LocalModel>[];

  final List<PieceOfClothingModel> _pieceOfClothingList =
      <PieceOfClothingModel>[];

  final List<PieceOfClothingTypeModel> _pieceOfClothingTypeList =
      <PieceOfClothingTypeModel>[];

  final List<TypeUseModel> _typeUseList = <TypeUseModel>[];

  final List<UseModel> _useList = <UseModel>[];

  LocalModel? _localSelected;
  PieceOfClothingTypeModel? _pieceOfClothingTypeSelected;

  List<LocalModel> get localList {
    if (_pieceOfClothingTypeSelected == null) {
      return List<LocalModel>.empty();
    }

    final localFiltered = _localList.where(
      (
        wLocal,
      ) =>
          _typeUseList.any(
        (
          aTypeUse,
        ) =>
            (_pieceOfClothingTypeSelected!.id ==
                aTypeUse.pieceOfClothingTypeId) &&
            (wLocal.id == aTypeUse.localId),
      ),
    );

    return List<LocalModel>.unmodifiable(
      localFiltered,
    );
  }

  LocalModel? get localSelected => _localSelected;

  List<PieceOfClothingTypeModel> get pieceOfClothingTypeList =>
      List.unmodifiable(
        _pieceOfClothingTypeList,
      );

  PieceOfClothingTypeModel? get pieceOfClothingTypeSelected =>
      _pieceOfClothingTypeSelected;

  List<UseModel> get useList => List.unmodifiable(
        _useList,
      );

  Future<Result> getPieceOfClothingUseList() async {
    if ((_pieceOfClothingTypeSelected == null) || (_localSelected == null)) {
      _populateUseList(
        data: [],
      );
      return Result.warning();
    }

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
      ApiUrl.uses.path,
      queryParameters: {
        ModelsEnum.pieceOfClothingType.name: _pieceOfClothingTypeSelected!.id,
        ModelsEnum.local.name: _localSelected!.id,
      },
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      _populateUseList(
        data: response.data,
      );
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return response.withoutData();
  }

  Future<Result> revalidateData({
    bool refresh = false,
    PieceOfClothingTypeModel? newPieceOfClothingType,
    LocalModel? newLocal,
  }) async {
    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    if (refresh) {
      final cancelToken = CancelToken();
      loadingBloc.show(
        cancelToken: cancelToken,
        isNotify: true,
      );

      var response = await _api.getResult(
        ApiUrl.chunk.path,
        cancelToken: cancelToken,
      );

      loadingBloc.hide(
        isNotify: false,
      );

      _populateBaseData(
        data: (response.status == ResultStatus.success) ? response.data : [],
      );
    }

    newPieceOfClothingType ??= _pieceOfClothingTypeSelected;

    if ((newPieceOfClothingType != null) &&
        (!_pieceOfClothingTypeList.contains(
          newPieceOfClothingType,
        ))) {
      newPieceOfClothingType = null;
    }

    newPieceOfClothingType ??= _pieceOfClothingTypeList.firstOrNull;

    final pieceOfClothingTypeChanged =
        _pieceOfClothingTypeSelected != newPieceOfClothingType;

    _pieceOfClothingTypeSelected = newPieceOfClothingType;

    newLocal ??= _localSelected;

    if ((newLocal != null) &&
        (!localList.contains(
          newLocal,
        ))) {
      newLocal = null;
    }

    if (localList.length == 1) {
      newLocal ??= localList.first;
    }

    final localChanged = _localSelected != newLocal;

    _localSelected = newLocal;

    if ((_pieceOfClothingTypeSelected == null) || (_localSelected == null)) {
      _populateUseList(
        data: [],
      );
    } else if (pieceOfClothingTypeChanged || localChanged) {
      final cancelToken = CancelToken();
      loadingBloc.show(
        cancelToken: cancelToken,
        isNotify: true,
      );

      var response = await _api.getResult(
        ApiUrl.uses.path,
        queryParameters: {
          ModelsEnum.pieceOfClothingType.name: _pieceOfClothingTypeSelected!.id,
          ModelsEnum.local.name: _localSelected!.id,
        },
        cancelToken: cancelToken,
      );

      loadingBloc.hide(
        isNotify: false,
      );

      if (response.status == ResultStatus.success) {
        _populateUseList(
          data: response.data,
        );
      }
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return Result.success();
  }

  _linkPieceOfClothings() {
    // forEach removed because of avoid_function_literals_in_foreach_calls
    for (final fPieceOfClothing in _pieceOfClothingList) {
      fPieceOfClothing.pieceOfClothingType =
          _pieceOfClothingTypeList.singleWhere(
        (
          swPieceOfClothingType,
        ) =>
            fPieceOfClothing.pieceOfClothingTypeId == swPieceOfClothingType.id,
      );
    }
  }

  _linkTypeUses() {
    for (final fTypeUse in _typeUseList) {
      fTypeUse.pieceOfClothingType = _pieceOfClothingTypeList.singleWhere(
        (
          swPieceOfClothingType,
        ) =>
            fTypeUse.pieceOfClothingTypeId == swPieceOfClothingType.id,
      );

      fTypeUse.local = _localList.singleWhere(
        (
          swLocal,
        ) =>
            fTypeUse.localId == swLocal.id,
      );
    }
  }

  _linkUses() {
    for (final fUse in _useList) {
      fUse.pieceOfClothing = _pieceOfClothingList.singleWhere(
        (
          swPieceOfClothing,
        ) =>
            fUse.pieceOfClothingId == swPieceOfClothing.id,
      );
    }
  }

  _populateBaseData({
    required data,
  }) {
    _pieceOfClothingTypeList.clear();
    _pieceOfClothingTypeList.addAll(
      PieceOfClothingTypeModel.fromList(
        data[ModelsEnum.pieceOfClothingType.name],
      ),
    );
    _pieceOfClothingTypeList.sort();

    _localList.clear();
    _localList.addAll(
      LocalModel.fromList(
        data[ModelsEnum.local.name],
      ),
    );
    _localList.sort();

    _typeUseList.clear();
    _typeUseList.addAll(
      TypeUseModel.fromList(
        data[ModelsEnum.typeUse.name],
      ),
    );

    _linkTypeUses();

    _pieceOfClothingList.clear();
    _pieceOfClothingList.addAll(
      PieceOfClothingModel.fromList(
        data[ModelsEnum.pieceOfClothing.name],
      ),
    );

    _linkPieceOfClothings();
  }

  _populateUseList({
    required data,
  }) {
    _useList.clear();
    _useList.addAll(
      UseModel.fromList(
        data,
      ),
    );

    _linkUses();

    _useList.sort();
  }
}
