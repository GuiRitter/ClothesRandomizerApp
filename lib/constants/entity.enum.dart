import 'package:clothes_randomizer_app/constants/api_url.enum.dart';

enum EntityModel {
  local(
    entityName: "local",
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

  final ApiUrl listUrl;

  final List<String> columnDisplayList;

  final List<String> columnHiddenList;

  const EntityModel({
    required this.entityName,
    required this.listUrl,
    required this.columnDisplayList,
    required this.columnHiddenList,
  });

  List<String> get columnList => [
        ...columnHiddenList,
        ...columnDisplayList,
      ];
}
