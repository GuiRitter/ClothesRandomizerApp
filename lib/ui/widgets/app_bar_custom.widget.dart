import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar appBarCustom({
  required BuildContext context,
  Widget? leading,
  String? subtitle,
  List<Widget>? actions,
}) {
  var l10n = AppLocalizations.of(
    context,
  )!;

  final theme = Theme.of(
    context,
  );

  final title = (subtitle == null)
      ? Text(
          l10n.title,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.title,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              subtitle,
            ),
          ],
        );

  return AppBar(
    leading: leading,
    title: title,
    actions: actions,
  );
}
