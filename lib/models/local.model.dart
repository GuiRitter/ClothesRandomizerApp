import 'package:clothes_randomizer_app/models/template.model.dart';

class LocalModel extends TemplateModel {
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

  static List<LocalModel> fromList(
    List<dynamic> query,
  ) =>
      TemplateModel.fromList(query, LocalModel.fromJson);
}
