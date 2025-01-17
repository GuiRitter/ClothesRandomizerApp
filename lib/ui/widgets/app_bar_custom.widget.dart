import 'package:clothes_randomizer_app/ui/pages/home.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_guiritter/util/logger.dart';

double? appBarElevation;

final _log = logger("appBarCustom");

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
    key: appBarKey,
    leading: leading,
    title: title,
    actions: actions,
  );
}

Future<double> getAppBarElevation({
  required int delay,
}) async {
  _log("getAppBarElevation").raw("delay", delay).print();

  if (appBarElevation != null) {
    return appBarElevation!;
  }

  await Future.delayed(
    Duration(
      microseconds: delay,
    ),
  );

  final BuildContext? context = appBarKey.currentContext;

  if (context != null) {
    final statefulElement = context as StatefulElement;

    SingleChildRenderObjectElement? singleChildRenderObjectElement;

    statefulElement.visitChildElements(
      (
        element,
      ) {
        singleChildRenderObjectElement =
            element as SingleChildRenderObjectElement;
      },
    );

    final semantics = singleChildRenderObjectElement!.widget as Semantics;

    final annotatedRegion = semantics.child as AnnotatedRegion;

    final material = annotatedRegion.child as Material;

    appBarElevation = material.elevation;

    return appBarElevation!;
  } else {
    return await getAppBarElevation(
      delay: delay + 1,
    );
  }
}
