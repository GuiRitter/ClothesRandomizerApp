import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EntityWritePage extends StatelessWidget {
  const EntityWritePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: appBarCustom(
        context: context,
        leading: BackButton(
          onPressed: () => onBackPressed(
            context: context,
          ),
        ),
        subtitle: "${l10n.createEntity}${l10n.entityName(
          entityBloc.entity!.entityName,
        )}",
      ),
      body: const Center(
        child: Text(
          "Hello, World!",
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

    entityBloc.manageEntity(
      entityModel: entityBloc.entity!,
    );
  }
}
