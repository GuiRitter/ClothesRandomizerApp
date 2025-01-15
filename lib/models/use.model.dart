import 'package:clothes_randomizer_app/models/piece_of_clothing.model.dart';
import 'package:clothes_randomizer_app/models/template.model.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:clothes_randomizer_app/utils/string.comparator.dart';
import 'package:flutter_guiritter/extension/date_time.dart';

class UseModel extends TemplateModel implements Comparable<UseModel>, Loggable {
  final int counter;

  final String pieceOfClothingId;
  PieceOfClothingModel? pieceOfClothing;

  final DateTime? lastDateTime;

  bool isIgnored = false;

  UseModel({
    required this.pieceOfClothingId,
    required this.counter,
    required this.lastDateTime,
  });

  factory UseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      UseModel(
        pieceOfClothingId: json["id"],
        counter: json["counter"] ?? 0,
        lastDateTime: ((json["last_date_time"] != null) &&
                (json["last_date_time"] as String).isNotEmpty)
            ? DateTime.parse(
                json["last_date_time"],
              ).toLocal()
            : null,
      );

  @override
  Map<String, dynamic> asLog() => <String, dynamic>{
        "pieceOfClothingId": pieceOfClothingId,
        "pieceOfClothing": getExistsMark(
          pieceOfClothing,
        ),
        "counter": counter,
        "lastDateTime": lastDateTime.toISO8601WithTimeZoneString(),
      };

  @override
  int compareTo(
    UseModel other,
  ) =>
      StringComparator.compare(
        alpha: pieceOfClothing!.name,
        bravo: other.pieceOfClothing!.name,
      );

  static List<UseModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(
        query,
        UseModel.fromJson,
      );
}
