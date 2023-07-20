class UseUpdateModel {
  late String local;
  late String pieceOfClothing;

  UseUpdateModel({
    required this.local,
    required this.pieceOfClothing,
  });

  UseUpdateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    local = json["local"];
    pieceOfClothing = json["pieceOfClothing"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["local"] = local;
    data["pieceOfClothing"] = pieceOfClothing;
    return data;
  }
}
