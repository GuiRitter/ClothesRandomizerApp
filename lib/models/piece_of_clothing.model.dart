import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/template.model.dart';

class PieceOfClothingModel extends TemplateModel {
  final String id;
  final String name;

  final String pieceOfClothingTypeId;
  PieceOfClothingTypeModel? pieceOfClothingType;

  PieceOfClothingModel({
    required this.id,
    required this.pieceOfClothingTypeId,
    required this.name,
  });

  factory PieceOfClothingModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      PieceOfClothingModel(
        id: json["id"],
        pieceOfClothingTypeId: json["type"],
        name: json["name"],
      );

  static List<PieceOfClothingModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(query, PieceOfClothingModel.fromJson);
}
