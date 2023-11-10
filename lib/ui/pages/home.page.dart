import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_popup_menu.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/type_and_local_drop_down.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/use.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/use.widget.dart'
    as use_widget;
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final GlobalKey appBarKey = GlobalKey();

final _log = logger("HomePage");

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final theme = Theme.of(
      context,
    );

    final fieldPadding = theme.textTheme.labelLarge?.fontSize ?? 0.0;

    // final halfFieldPadding = fieldPadding / 2.0;
    // final doubleFieldPadding = fieldPadding * 2.0;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    return Scaffold(
      appBar: appBarCustom(
        context: context,
        actions: [
          AppBarPopupMenuWidget.signedIn(),
        ],
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TypeAndLocalDropDown(
              isShowLocal: true,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataBloc.useList.length,
                itemBuilder: (
                  context,
                  index,
                ) =>
                    UseWidget(
                  index: index,
                ),
              ),
            ),
            BottomAppBar(
              color: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.all(
                fieldPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onRandomPressed(
                    context: context,
                    dataBloc: dataBloc,
                  ),
                  child: Text(
                    l10n.randomizeButtonString,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRandomPressed({
    required BuildContext context,
    required DataBloc dataBloc,
  }) {
    _log("onRandomPressed")
        .exists("context", context)
        .exists("dataBloc", dataBloc)
        .print();

    if (dataBloc.localSelected == null) {
      openDropdown();
      return;
    }

    use_widget.onRandomPressed(
      context: context,
      dataBloc: dataBloc,
    );
  }
}
