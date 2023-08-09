import 'dart:math';

import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/constants/api_url.enum.dart';
import 'package:clothes_randomizer_app/constants/models.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/constants/sign.enum.dart';
import 'package:clothes_randomizer_app/models/candidate.model.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/result.dart';
import 'package:clothes_randomizer_app/models/type_use.model.dart';
import 'package:clothes_randomizer_app/models/use.model.dart';
import 'package:clothes_randomizer_app/models/use_update.model.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _log = logger("DataBloc");

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
  UseModel? _useSelected;

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

  UseModel? get useSelected => _useSelected;

  clearUseSelected() {
    _log("clearUseSelected").print();

    return _useSelected = null;
  }

  Future<Result> drawPieceOfClothing() async {
    _log("drawPieceOfClothing").print();

    if ((_pieceOfClothingTypeSelected == null) || (_localSelected == null)) {
      return Result.warning();
    }
    final candidateList = _useList.fold(
      CandidateModel.empty(),
      (
        previousCandidates,
        fUse,
      ) {
        if ((previousCandidates.lowestCount == null) ||
            (fUse.counter < previousCandidates.lowestCount!)) {
          return CandidateModel.withLowestCountAndUse(
            lowestCount: fUse.counter,
            useModel: fUse,
          );
        } else if (fUse.counter == previousCandidates.lowestCount!) {
          return previousCandidates.withUse(
            anotherUse: fUse,
          );
        }
        return previousCandidates;
      },
    ).list;

    final rng = Provider.of<Random>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    _useSelected = candidateList.elementAt(
      rng.nextInt(
        candidateList.length,
      ),
    );

    return Result.success();
  }

  Future<Result> revalidateData({
    bool refreshBaseData = false,
    PieceOfClothingTypeModel? newPieceOfClothingType,
    LocalModel? newLocal,
    bool refreshUseList = false,
  }) async {
    _log("revalidateData")
        .raw("refreshBaseData", refreshBaseData)
        .map("newPieceOfClothingType", newPieceOfClothingType)
        .map("newLocal", newLocal)
        .raw("refreshUseList", refreshUseList)
        .print();

    final loadingBloc = Provider.of<LoadingBloc>(
      Settings.navigatorState.currentContext!,
      listen: false,
    );

    if (refreshBaseData) {
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
    } else if (refreshUseList || pieceOfClothingTypeChanged || localChanged) {
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

  selectUse({
    required UseModel use,
  }) {
    _log("selectUse").map("use", use).print();

    return _useSelected = use;
  }

  Future<Result> updateUse({
    required SignEnum sign,
  }) async {
    _log("updateUse").enum_("sign", sign).print();

    if ((_useSelected == null) || (_localSelected == null)) {
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

    var response = await _api.postResult(
      (sign == SignEnum.plus)
          ? ApiUrl.incrementUse.path
          : ApiUrl.decrementUse.path,
      data: UseUpdateModel(
        pieceOfClothing: _useSelected!.pieceOfClothing!.id,
        local: _localSelected!.id,
        newLastDateTime: DateTime.now(),
      ).toJson(),
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      return revalidateData(
        refreshUseList: true,
      );
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return response.withoutData();
  }

  _linkPieceOfClothings() {
    _log("_linkPieceOfClothings").print();

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
    _log("_linkTypeUses").print();

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
    _log("_linkUses").print();

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
    _log("_populateBaseData").raw("data", data).print();

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
    _log("_populateUseList").raw("data", data).print();

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
