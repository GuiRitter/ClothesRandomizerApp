import 'package:flutter_guiritter/extension/date_time.dart';

class UseUpdateModel {
  late String local;
  late String pieceOfClothing;
  late DateTime? newLastDateTime;

  UseUpdateModel({
    required this.local,
    required this.pieceOfClothing,
    required this.newLastDateTime,
  });

  UseUpdateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    local = json["local"];
    pieceOfClothing = json["pieceOfClothing"];
    newLastDateTime = (json["newLastDateTime"] != null)
        ? DateTime.parse(
            json["newLastDateTime"],
          ).toLocal()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["local"] = local;
    data["pieceOfClothing"] = pieceOfClothing;
    data["newLastDateTime"] = (newLastDateTime != null)
        ? newLastDateTime!.toISO8601WithTimeZoneString()
        : null;
    return data;
  }
}
