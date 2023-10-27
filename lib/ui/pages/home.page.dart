import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_popup_menu.widget.dart';
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
  final GlobalKey localDropDownKey = GlobalKey();

  HomePage({
    super.key,
  });

  /// https://stackoverflow.com/a/59499191/1781376
  ///
  /// https://gist.github.com/spauldhaliwal/942eec24895a7ed79e342aa784a62fa6
  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext? element) {
      element?.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
        } else {
          searchForGestureDetector(element);
        }
      });
    }

    searchForGestureDetector(localDropDownKey.currentContext);
    assert(detector != null);

    detector?.onTap?.call();
  }

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
            FutureBuilder<double>(
              future: getAppBarElevation(
                delay: 0,
              ),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot.hasData && (snapshot.data != null)) {
                  return Material(
                    elevation: snapshot.data!,
                    child: Padding(
                      padding: EdgeInsets.all(
                        fieldPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.selectTypeString,
                          ),
                          ListTile(
                            title: DropdownButton<PieceOfClothingTypeModel>(
                              value: dataBloc.pieceOfClothingTypeSelected,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              isExpanded: true,
                              onChanged: (
                                value,
                              ) =>
                                  onPieceOfClothingTypeChanged(
                                context: context,
                                value: value,
                              ),
                              items: dataBloc.pieceOfClothingTypeList
                                  .map(
                                    (
                                      mPieceOfClothingType,
                                    ) =>
                                        DropdownMenuItem<
                                            PieceOfClothingTypeModel>(
                                      value: mPieceOfClothingType,
                                      child: Text(
                                        mPieceOfClothingType.name,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox.square(
                            dimension: fieldPadding,
                          ),
                          Text(
                            l10n.selectLocationString,
                          ),
                          ListTile(
                            title: DropdownButton<LocalModel>(
                              key: localDropDownKey,
                              value: dataBloc.localSelected,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              isExpanded: true,
                              onChanged: (
                                value,
                              ) =>
                                  onLocalChanged(
                                context: context,
                                value: value,
                              ),
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
                          SizedBox.square(
                            dimension: fieldPadding,
                          ),
                          Text(
                            l10n.usesString,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
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
    if (dataBloc.localSelected == null) {
      openDropdown();
      return;
    }

    use_widget.onRandomPressed(
      context: context,
      dataBloc: dataBloc,
    );
  }

  Future<double> getAppBarElevation({
    required int delay,
  }) async {
    _log("getAppBarElevation").raw("delay", delay).print();

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

      return material.elevation;
    } else {
      return await getAppBarElevation(
        delay: delay + 1,
      );
    }
  }

  onLocalChanged({
    required BuildContext context,
    required LocalModel? value,
  }) {
    _log("onLocalChanged").map("value", value).print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.revalidateData(
      newLocal: value,
    );
  }

  onPieceOfClothingTypeChanged({
    required BuildContext context,
    required PieceOfClothingTypeModel? value,
  }) {
    _log("onPieceOfClothingTypeChanged").map("value", value).print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.revalidateData(
      newPieceOfClothingType: value,
    );
  }
}
