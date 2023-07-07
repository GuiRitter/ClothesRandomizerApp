import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/template.model.dart';

class TypeUseModel extends TemplateModel {
  final String pieceOfClothingTypeId;
  PieceOfClothingTypeModel? pieceOfClothingType;

  final String localId;
  LocalModel? local;

  TypeUseModel({
    required this.pieceOfClothingTypeId,
    required this.localId,
  });

  factory TypeUseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      TypeUseModel(
        pieceOfClothingTypeId: json["type"],
        localId: json["local"],
      );

  static List<TypeUseModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(query, TypeUseModel.fromJson);
}
