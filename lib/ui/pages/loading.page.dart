import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    var l10n = AppLocalizations.of(
      context,
    )!;

    final padding = Theme.of(
          context,
        ).textTheme.titleLarge?.fontSize ??
        0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(
                context,
              )!
                  .title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall,
            ),
            Text(
              l10n.loading,
            ),
          ],
        ),
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
                l10n.cancel,
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
    final loadingBloc = Provider.of<LoadingBloc>(
      context,
      listen: false,
    );

    loadingBloc.cancelRequest();
  }
}
