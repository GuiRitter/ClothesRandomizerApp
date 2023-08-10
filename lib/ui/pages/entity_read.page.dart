import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
              style: Theme.of(
                context,
              ).textTheme.bodySmall,
            ),
            Text(
              l10n.entitiesName(
                entityBloc.entity!.entityName,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Table(
          columnWidths: {
            for (var element in entityBloc.entity!.columnDisplayList.indexed)
              element.$1: const IntrinsicColumnWidth()
          },
          children: entityBloc.entityList
              .map(
                (
                  mEntity,
                ) =>
                    TableRow(
                  children: entityBloc.entity!.columnDisplayList
                      .map(
                        (
                          mColumn,
                        ) =>
                            Text(
                          mEntity[mColumn],
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
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
