import 'package:clothes_randomizer_app/constants/entity.enum.dart';

extension EntityHasDependency on Map<String, dynamic> {
  bool hasDependency() {
    return this[hasDependencyColumn];
  }
}

extension EntityIdOnly on Map<String, dynamic> {
  Map<String, dynamic> asIdOnly() => Map<String, dynamic>.fromEntries(
        entries.where(
          (
            entry,
          ) =>
              entry.key == identityColumn,
        ),
      );
}
