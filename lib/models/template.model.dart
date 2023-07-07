class TemplateModel {
  TemplateModel();

  factory TemplateModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      TemplateModel();

  static List<T> fromList<T>(
    List<dynamic> query,
    T Function(
      Map<String, dynamic> json,
    ) constructor,
  ) =>
      query
          .map(
            (
              item,
            ) =>
                constructor(
              item,
            ),
          )
          .toList();
}
