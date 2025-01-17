import 'package:clothes_randomizer_app/models/template.model.dart';
import 'package:clothes_randomizer_app/utils/string.comparator.dart';
import 'package:flutter_guiritter/util/logger.dart';

class PieceOfClothingTypeModel extends TemplateModel
    implements Comparable<PieceOfClothingTypeModel>, Loggable {
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

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! PieceOfClothingTypeModel) {
      return false;
    }
    return id == other.id;
  }

  @override
  Map<String, dynamic> asLog() => <String, dynamic>{
        "id": id,
        "name": name,
      };

  @override
  int compareTo(
    PieceOfClothingTypeModel other,
  ) =>
      StringComparator.compare(
        alpha: name,
        bravo: other.name,
      );

  static List<PieceOfClothingTypeModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(
        query,
        PieceOfClothingTypeModel.fromJson,
      );
}
