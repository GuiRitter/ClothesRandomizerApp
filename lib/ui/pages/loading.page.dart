import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guiritter/common/common.import.dart'
    as common_gui_ritter show AppLocalizationsGuiRitter, l10nGuiRitter;
import 'package:flutter_guiritter/util/logger.dart';
import 'package:provider/provider.dart';

final _log = logger("LoadingPage");

common_gui_ritter.AppLocalizationsGuiRitter get l10nGuiRitter =>
    common_gui_ritter.l10nGuiRitter!;

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final padding = Theme.of(
          context,
        ).textTheme.titleLarge?.fontSize ??
        0.0;

    return Scaffold(
      appBar: appBarCustom(
        context: context,
        subtitle: l10nGuiRitter.loading,
      ),
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: padding,
          children: [
            const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () => onCancelPressed(
                context: context,
              ),
              child: Text(
                l10nGuiRitter.cancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  onCancelPressed({
    required BuildContext context,
  }) {
    _log("onCancelPressed").print();

    final loadingBloc = Provider.of<LoadingBloc>(
      context,
      listen: false,
    );

    loadingBloc.cancelRequest();
  }
}
