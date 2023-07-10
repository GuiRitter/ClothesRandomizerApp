import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/popup_menu.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final fieldPadding = Theme.of(
          context,
        ).textTheme.labelLarge?.fontSize ??
        0.0;

    // final halfFieldPadding = fieldPadding / 2.0;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.title,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (
              context,
            ) {
              return [
                PopupMenuItem(
                  value: PopupMenuEnum.signOut,
                  child: Text(
                    l10n.signOut,
                  ),
                ),
              ];
            },
            onSelected: (
              value,
            ) =>
                onSignOut(
              context: context,
              value: value,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Padding(
          padding: EdgeInsets.all(
            fieldPadding,
          ),
          child: DropdownButton<LocalModel>(
            value: dataBloc.localSelected,
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
            onChanged: onLocalChanged,
            items: dataBloc.localList
                .map(
                  (
                    mLocal,
                  ) =>
                      DropdownMenuItem<LocalModel>(
                    value: mLocal,
                    child: Text(
                      mLocal.name,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

// TODO get the dependency blocs using the context from the global key instead of from passing in the constructor

  @override
  void initState() {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.getBaseData().then(
      (
        result,
      ) {
        if (result.hasMessageNotIn(
          status: ResultStatus.success,
        )) {
          showSnackBar(
            message: result.message,
          );
        }
      },
    );

    super.initState();
  }

  onLocalChanged(
    LocalModel? value,
  ) {
    // TODO
  }

  onSignOut({
    required BuildContext context,
    required PopupMenuEnum value,
  }) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    userBloc.validateAndSetToken(newToken: null);
  }
}
