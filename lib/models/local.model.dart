import 'package:clothes_randomizer_app/models/template.model.dart';
import 'package:clothes_randomizer_app/utils/string.comparator.dart';
import 'package:flutter_guiritter/util/logger.dart';

class LocalModel extends TemplateModel
    implements Comparable<LocalModel>, Loggable {
  final String id;
  final String name;

  LocalModel({
    required this.id,
    required this.name,
  });

  @override
  factory LocalModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      LocalModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! LocalModel) {
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
    LocalModel other,
  ) =>
      StringComparator.compare(
        alpha: name,
        bravo: other.name,
      );

  static List<LocalModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(
        query,
        LocalModel.fromJson,
      );
}
