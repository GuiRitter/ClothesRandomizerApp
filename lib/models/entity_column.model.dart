import 'package:clothes_randomizer_app/constants/entity.enum.dart';
import 'package:clothes_randomizer_app/constants/entity_column.enum.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';

bool columnIsDisplay(EntityColumnModel model) => model.isDisplay;

/// Metadata about an entity's property,
/// which is represented by a column in a database.
class EntityColumnModel implements Loggable {
  /// The kind of data: int, String, entity etc.
  final EntityColumnKind kind;

  /// The specific type of data: int, String, user, product etc.
  final String type;

  /// The name of the entity's property:
  /// first name, last name, date of birth, date of death etc.
  final String name;

  /// If the column should be displayed to the used.
  final bool isDisplay;

  /// Should receive values from [AutofillHints].
  final List<String> hints;

  const EntityColumnModel({
    required this.kind,
    required this.type,
    required this.name,
    required this.isDisplay,
    required this.hints,
  });

  EntityModel getModel() => EntityModel.values.singleWhere(
        (
          entityModel,
        ) =>
            type == entityModel.name,
      );

  String get nameId => name.replaceAll(
        "__display",
        "",
      );

  @override
  Map<String, dynamic> asLog() => <String, dynamic>{
        "kind": kind.name,
        "type": type,
        "name": name,
        "isDisplay": isDisplay,
        "hints": hints,
      };
}
