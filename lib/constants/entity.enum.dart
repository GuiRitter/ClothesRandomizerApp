import 'package:clothes_randomizer_app/constants/api_url.enum.dart';
import 'package:clothes_randomizer_app/constants/entity_column.enum.dart';
import 'package:clothes_randomizer_app/models/entity_column.model.dart';
import 'package:flutter/material.dart';

const hasDependencyColumn = "has_dependency";
const identityColumn = "id";

enum EntityModel {
  local(
    entityName: "local",
    baseUrl: ApiUrl.local,
    listUrl: ApiUrl.localList,
    columnList: [
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "id",
        isDisplay: false,
        hints: [],
      ),
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "name",
        isDisplay: true,
        hints: [
          AutofillHints.location,
        ],
      ),
    ],
  ),
  pieceOfClothingType(
    entityName: "piece_of_clothing_type",
    baseUrl: ApiUrl.pieceOfClothingType,
    listUrl: ApiUrl.pieceOfClothingTypeList,
    columnList: [
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "id",
        isDisplay: false,
        hints: [],
      ),
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "name",
        isDisplay: true,
        hints: [],
      ),
    ],
  ),
  pieceOfClothing(
    entityName: "piece_of_clothing",
    baseUrl: ApiUrl.pieceOfClothing,
    listUrl: ApiUrl.pieceOfClothingList,
    columnList: [
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "id",
        isDisplay: false,
        hints: [],
      ),
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "type",
        isDisplay: false,
        hints: [],
      ),
      EntityColumnModel(
        kind: EntityColumnKind.entitySingle,
        type: "pieceOfClothingType",
        name: "type__display",
        isDisplay: true,
        hints: [],
      ),
      EntityColumnModel(
        kind: EntityColumnKind.text,
        type: "String",
        name: "name",
        isDisplay: true,
        hints: [],
      ),
    ],
  );

  final String entityName;

  final ApiUrl baseUrl;
  final ApiUrl listUrl;

  final List<EntityColumnModel> columnList;

  const EntityModel({
    required this.entityName,
    required this.baseUrl,
    required this.listUrl,
    required this.columnList,
  });

  List<EntityColumnModel> get columnDisplayList => columnList
      .where(
        columnIsDisplay,
      )
      .toList();

  String getDescription(
    Map<String, dynamic> entity,
  ) =>
      columnDisplayList
          .map(
            (
              mColumn,
            ) =>
                entity[mColumn.name],
          )
          .join(" ");

  static EntityModel getModelByName(
    String name,
  ) =>
      EntityModel.values.singleWhere(
        (
          model,
        ) =>
            name == model.name,
      );
}
