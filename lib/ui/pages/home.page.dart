import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    // final fieldPadding = Theme.of(
    //       context,
    //     ).textTheme.labelLarge?.fontSize ??
    //     0.0;

    // final halfFieldPadding = fieldPadding / 2.0;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.title,
        ),
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Padding(
          padding: EdgeInsets.all(
            Theme.of(
                  context,
                ).textTheme.labelLarge?.fontSize ??
                0,
          ),
          child: const Center(
            child: Text(
              "Hello, World!",
            ),
          ),
        ),
      ),
    );
  }
}
