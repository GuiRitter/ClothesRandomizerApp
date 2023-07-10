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

  LocalModel? localSelected;
  PieceOfClothingModel? pieceOfClothingSelected;
  PieceOfClothingTypeModel? pieceOfClothingTypeSelected;
  TypeUseModel? typeUseSelected;

  List<LocalModel> get localList => List.unmodifiable(
        _localList,
      );

  List<PieceOfClothingModel> get pieceOfClothingList => List.unmodifiable(
        _pieceOfClothingList,
      );

  List<PieceOfClothingTypeModel> get pieceOfClothingTypeList =>
      List.unmodifiable(
        _pieceOfClothingTypeList,
      );

  List<TypeUseModel> get typeUseList => List.unmodifiable(
        _typeUseList,
      );

  Future<Result> getBaseData() async {
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
      ApiUrl.chunk.path,
      cancelToken: cancelToken,
    );

    loadingBloc.hide(
      isNotify: false,
    );

    if (response.status == ResultStatus.success) {
      _populateBaseData(response.data);
    }

    loadingBloc.notifyListeners();
    notifyListeners();

    return response.withData(
      handler: (
        data,
      ) =>
          null,
    );
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

  _populateBaseData(
    data,
  ) {
    _localList.clear();
    _localList.addAll(
      LocalModel.fromList(
        data[ModelsEnum.local.name],
      ),
    );
    _localList.sort();

    _pieceOfClothingTypeList.clear();
    _pieceOfClothingTypeList.addAll(
      PieceOfClothingTypeModel.fromList(
        data[ModelsEnum.pieceOfClothingType.name],
      ),
    );

    _pieceOfClothingList.clear();
    _pieceOfClothingList.addAll(
      PieceOfClothingModel.fromList(
        data[ModelsEnum.pieceOfClothing.name],
      ),
    );

    _linkPieceOfClothings();

    _typeUseList.clear();
    _typeUseList.addAll(
      TypeUseModel.fromList(
        data[ModelsEnum.typeUse.name],
      ),
    );

    _linkTypeUses();

    localSelected ??= localList.first;
  }
}
