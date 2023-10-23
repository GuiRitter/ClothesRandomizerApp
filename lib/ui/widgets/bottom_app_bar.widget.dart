import 'package:flutter/material.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';

double? _elevation;

final _key = GlobalKey();

final _log = logger("BottomAppBarWidget");

Widget build({
  required BuildContext context,
  Widget? child,
}) {
  final theme = Theme.of(
    context,
  );

  final fieldPadding = theme.textTheme.labelLarge?.fontSize ?? 0.0;

  final bottomAppBar = BottomAppBar(
    key: _key,
    padding: EdgeInsets.all(
      fieldPadding,
    ),
    child: child,
  );

  return ValueListenableBuilder(
    valueListenable: themeNotifier,
    builder: (_, value, __) {
      if (value.mode == ThemeMode.light) {
        return bottomAppBar;
      }

      return FutureBuilder(
        future: getElevation(
          delay: 0,
        ),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[snapshot.data]!
                    .map(
                      (
                        boxShadow,
                      ) =>
                          BoxShadow(
                        blurRadius: boxShadow.blurRadius,
                        blurStyle: boxShadow.blurStyle,
                        color: (theme.appBarTheme.shadowColor ?? Colors.grey)
                            .withAlpha(
                          64,
                        ),
                        offset: boxShadow.offset,
                        spreadRadius: boxShadow.spreadRadius,
                      ),
                    )
                    .toList(),
              ),
              child: bottomAppBar,
            );
          } else {
            return bottomAppBar;
          }
        },
      );
    },
  );
}

Future<double> getElevation({
  required int delay,
}) async {
  _log("getBottomAppBarElevation").raw("delay", delay).print();

  if (_elevation != null) {
    return _elevation!;
  }

  await Future.delayed(
    Duration(
      microseconds: delay,
    ),
  );

  final BuildContext? placeHolderContext = _key.currentContext;

  if ((placeHolderContext != null) && (placeHolderContext.mounted)) {
    StatefulElement? statefulElement = placeHolderContext as StatefulElement;

    SingleChildRenderObjectElement? singleChildRenderObjectElement;

    statefulElement.visitChildElements(
      (
        element,
      ) {
        singleChildRenderObjectElement =
            element as SingleChildRenderObjectElement;
      },
    );

    final physicalShape =
        singleChildRenderObjectElement!.widget as PhysicalShape;

    _elevation = physicalShape.elevation;

    return _elevation!;
  } else {
    return await getElevation(
      delay: delay + 1,
    );
  }
}
