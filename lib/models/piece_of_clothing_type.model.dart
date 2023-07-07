import 'package:clothes_randomizer_app/models/template.model.dart';

class PieceOfClothingTypeModel extends TemplateModel {
  final String id;
  final String name;

  PieceOfClothingTypeModel({
    required this.id,
    required this.name,
  });

  factory PieceOfClothingTypeModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      PieceOfClothingTypeModel(
        id: json["id"],
        name: json["name"],
      );

  static List<PieceOfClothingTypeModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(query, PieceOfClothingTypeModel.fromJson);
}
