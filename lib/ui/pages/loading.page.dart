import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    userBloc.cancelRequest();
  }
}
