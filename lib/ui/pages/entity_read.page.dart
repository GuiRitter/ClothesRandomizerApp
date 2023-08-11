import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => onBackPressed(
            context: context,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.title,
              style: theme.textTheme.bodySmall,
            ),
            Text(
              l10n.entitiesName(
                entityBloc.entity!.entityName,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            // onPressed: null,
            onPressed: () {},
            child: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              border: TableBorder(
                  bottom: borderSide,
                  left: borderSide,
                  right: borderSide,
                  top: borderSide),
              columns: [
                ...entityBloc.entity!.columnDisplayList.map(
                  (
                    mColumn,
                  ) =>
                      DataColumn(
                    label: _boldText(
                      label: l10n.entityHeader(
                        "${entityBloc.entity!.entityName}__$mColumn",
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
                        ...entityBloc.entity!.columnDisplayList.map(
                          (
                            mColumn,
                          ) =>
                              DataCell(
                            Text(
                              mEntity[mColumn],
                            ),
                          ),
                        ),
                        const DataCell(
                          ElevatedButton(
                            onPressed: null,
                            child: Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                        const DataCell(
                          ElevatedButton(
                            onPressed: null,
                            child: Icon(
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
    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    entityBloc.exit();
  }
}
