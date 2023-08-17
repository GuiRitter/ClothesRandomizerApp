import 'package:clothes_randomizer_app/constants/api_url.enum.dart';

const hasDependencyColumn = "has_dependency";
const identityColumn = "id";

enum EntityModel {
  local(
    entityName: "local",
    baseUrl: ApiUrl.local,
    listUrl: ApiUrl.localList,
    columnDisplayList: [
      "name",
    ],
    columnHiddenList: [
      "id",
    ],
  ),
  pieceOfClothingType(
    entityName: "piece_of_clothing_type",
    baseUrl: ApiUrl.pieceOfClothingType,
    listUrl: ApiUrl.pieceOfClothingTypeList,
    columnDisplayList: [
      "name",
    ],
    columnHiddenList: [
      "id",
    ],
  ),
  pieceOfClothing(
    entityName: "piece_of_clothing",
    baseUrl: ApiUrl.pieceOfClothing,
    listUrl: ApiUrl.pieceOfClothingList,
    columnDisplayList: [
      "piece_of_clothing_type",
      "name",
    ],
    columnHiddenList: [
      "id",
      "type",
    ],
  );

  final String entityName;

  final ApiUrl baseUrl;
  final ApiUrl listUrl;

  final List<String> columnDisplayList;

  final List<String> columnHiddenList;

  const EntityModel({
    required this.entityName,
    required this.baseUrl,
    required this.listUrl,
    required this.columnDisplayList,
    required this.columnHiddenList,
  });

  List<String> get columnList => [
        ...columnHiddenList,
        ...columnDisplayList,
      ];

  String getDescription(
    Map<String, dynamic> entity,
  ) =>
      columnDisplayList
          .map(
            (
              mColumn,
            ) =>
                entity[mColumn],
          )
          .join(" ");
}
