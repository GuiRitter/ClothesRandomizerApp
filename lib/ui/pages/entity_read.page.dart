import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/dialogs.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/dialog.widget.dart';
import 'package:clothes_randomizer_app/utils/entity.extension.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final _log = logger("EntityReadPage");

Widget _boldText({
  required String label,
}) =>
    Text(
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      label,
    );

class EntityReadPage extends StatelessWidget {
  const EntityReadPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    var l10n = AppLocalizations.of(
      context,
    )!;

    final entityBloc = Provider.of<EntityBloc>(
      context,
    );

    final theme = Theme.of(
      context,
    );

    final borderSide = BorderSide(
      color: theme.dividerColor,
    );

    return Scaffold(
      appBar: appBarCustom(
          context: context,
          leading: BackButton(
            onPressed: () => onBackPressed(
              context: context,
            ),
          ),
          subtitle: l10n.entitiesName(
            entityBloc.entityTemplate!.entityName,
          ),
          actions: [
            TextButton(
              onPressed: () => onCreatePressed(
                context: context,
              ),
              child: const Icon(
                Icons.add,
              ),
            ),
          ]),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              border: TableBorder(
                bottom: borderSide,
                left: borderSide,
                right: borderSide,
                top: borderSide,
              ),
              columns: [
                ...entityBloc.entityTemplate!.columnDisplayList.map(
                  (
                    mColumn,
                  ) =>
                      DataColumn(
                    label: _boldText(
                      label: l10n.entityHeader(
                        "${entityBloc.entityTemplate!.entityName}__${mColumn.name}",
                      ),
                    ),
                  ),
                ),
                const DataColumn(
                  label: SizedBox.shrink(),
                ),
                const DataColumn(
                  label: SizedBox.shrink(),
                ),
              ],
              rows: entityBloc.entityList
                  .map(
                    (
                      mEntity,
                    ) =>
                        DataRow(
                      // This is used in lieu of `dataRowColor` because it's not working
                      onLongPress: () {},
                      cells: [
                        ...entityBloc.entityTemplate!.columnDisplayList.map(
                          (
                            mColumn,
                          ) =>
                              DataCell(
                            Text(
                              mEntity[mColumn.name],
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () => onEditPressed(
                              context: context,
                              entity: mEntity,
                            ),
                            child: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () => onDeletePressed(
                              context: context,
                              entity: mEntity,
                            ),
                            child: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  onBackPressed({
    required BuildContext context,
  }) {
    _log("onBackPressed").print();

    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    entityBloc.exit();
  }

  onCreatePressed({
    required BuildContext context,
  }) {
    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    entityBloc.manageEntity(
      id: null,
    );
  }

  onDeletePressed({
    required BuildContext context,
    required Map<String, dynamic> entity,
  }) async {
    _log("onDeletePressed").raw("entity", entity).print();

    var l10n = AppLocalizations.of(
      context,
    )!;

    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    await showDialog(
      context: context,
      barrierColor: Theme.of(
        context,
      ).colorScheme.scrim,
      builder: (
        context,
      ) {
        return AlertDialog(
          content: Text(
            "${l10n.deleteEntity(
              entityBloc.entityTemplate!.entityName,
            )}${entityBloc.entityTemplate!.getDescription(
              entity,
            )}?${entity.hasDependency() ? l10n.deleteEntityDependency(
                entityBloc.entityTemplate!.entityName,
              ) : ""}",
          ),
          actions: [
            buildTextButton(
              label: l10n.keep,
              onPressed: () => onDialogCancelPressed(
                context: context,
              ),
            ),
            buildTextButton(
              label: l10n.remove,
              onPressed: () => onDialogOkPressed(
                context: context,
                entity: entity,
              ),
            ),
          ],
        );
      },
    );
  }

  onDialogOkPressed({
    required BuildContext context,
    required Map<String, dynamic> entity,
  }) async {
    _log("onDialogOkPressed").raw("entity", entity).print();

    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    if (context.mounted) {
      onDialogCancelPressed(
        context: context,
      );
    }

    final result = await entityBloc.deleteCascade(
      entityToDelete: entity,
    );

    if (result.hasMessageNotIn(
      status: ResultStatus.success,
    )) {
      showSnackBar(
        message: result.message,
      );
    }
  }

  onEditPressed({
    required BuildContext context,
    required Map<String, dynamic> entity,
  }) {
    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    entityBloc.manageEntity(
      id: entity["id"],
    );
  }
}
