import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/use_popup_menu.enum.dart';
import 'package:clothes_randomizer_app/dialogs.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/use.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_popup_menu.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/dialog.widget.dart';
import 'package:clothes_randomizer_app/utils/date_time.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final _log = logger("HomePage");

class HomePage extends StatelessWidget {
  final GlobalKey _appBarKey = GlobalKey();

  HomePage({
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
      appBar: AppBar(
        key: _appBarKey,
        title: Text(
          l10n.title,
        ),
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
                ) {
                  final use = dataBloc.useList[index];

                  final subtitle = [
                    l10n.usesPlural(
                      use.counter,
                    ),
                  ];

                  if (use.lastDateTime != null) {
                    subtitle.add(
                      l10n.lastUse(
                        formmatLastDateTime(
                          dateTime: use.lastDateTime!,
                        ),
                      ),
                    );
                  }

                  return ListTile(
                    enabled: !use.isIgnored,
                    title: Text(
                      use.pieceOfClothing!.name,
                    ),
                    subtitle: Text(
                      subtitle.join(
                        " ",
                      ),
                    ),
                    trailing: PopupMenuButton<UsePopupMenuEnum?>(
                      onOpened: () => onUsePopupMenuOpened(
                        context: context,
                        use: use,
                      ),
                      onCanceled: () => onUsePopupMenuCanceled(
                        context: context,
                      ),
                      itemBuilder: (
                        context,
                      ) {
                        final List<PopupMenuItem<UsePopupMenuEnum>> optionList =
                            [
                          PopupMenuItem<UsePopupMenuEnum>(
                            value: UsePopupMenuEnum.add,
                            child: Text(
                              l10n.menuAddItem,
                            ),
                          ),
                        ];

                        if (use.counter > 0) {
                          optionList.add(
                            PopupMenuItem<UsePopupMenuEnum>(
                              value: UsePopupMenuEnum.remove,
                              child: Text(
                                l10n.menuRemoveItem,
                              ),
                            ),
                          );
                        }

                        optionList.add(
                          PopupMenuItem<UsePopupMenuEnum>(
                            value: use.isIgnored
                                ? UsePopupMenuEnum.regard
                                : UsePopupMenuEnum.ignore,
                            child: Text(
                              use.isIgnored
                                  ? l10n.menuRegardItem
                                  : l10n.menuIgnoreItem,
                            ),
                          ),
                        );

                        optionList.add(
                          PopupMenuItem<UsePopupMenuEnum>(
                            value: null,
                            child: Text(
                              l10n.cancel,
                            ),
                          ),
                        );

                        return optionList;
                      },
                      onSelected: (
                        value,
                      ) =>
                          onUsePopupMenuItemPressed(
                        context: context,
                        value: value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.scaffoldBackgroundColor,
        padding: EdgeInsets.all(
          fieldPadding,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onRandomPressed(
              context: context,
            ),
            child: Text(
              l10n.randomizeButtonString,
            ),
          ),
        ),
      ),
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

    final BuildContext? context = _appBarKey.currentContext;

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

  onDialogIgnoreRegardPressed({
    required BuildContext context,
    required DataBloc dataBloc,
  }) {
    _log("onDialogIgnoreRegardPressed").print();
    onDialogCancelPressed(
      context: context,
    );
    dataBloc.setUseIgnored();
    onRandomPressed(
      context: context,
    );
  }

  onDialogOkPressed({
    required BuildContext context,
    required UsePopupMenuEnum useAction,
  }) async {
    _log("onDialogOkPressed").enum_("useAction", useAction).print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    onDialogCancelPressed(
      context: context,
    );

    final result = await dataBloc.updateUse(
      useAction: useAction,
    );

    if (result.status == ResultStatus.error) {
      showSnackBar(
        message: result.message,
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

  onRandomPressed({
    required BuildContext context,
  }) async {
    _log("onRandomPressed").print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );
    final drawResult = await dataBloc.drawPieceOfClothing();

    if ((drawResult.status != ResultStatus.success) ||
        (dataBloc.useSelected == null)) {
      return;
    }

    if (context.mounted) {
      await showConfirmDialog(
        context: context,
        dataBloc: dataBloc,
        useAction: UsePopupMenuEnum.add,
        showIgnore: true,
      );
    }
  }

  onUsePopupMenuCanceled({
    required BuildContext context,
  }) {
    _log("onUsePopupMenuCanceled").print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.clearUseSelected();
  }

  onUsePopupMenuItemPressed({
    required BuildContext context,
    required UsePopupMenuEnum? value,
  }) async {
    _log("onUsePopupMenuItemPressed").enum_("value", value).print();

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    if (value == null) {
      return;
    }

    if (((value == UsePopupMenuEnum.add) ||
            (value == UsePopupMenuEnum.remove)) &&
        (dataBloc.useSelected != null)) {
      await showConfirmDialog(
        context: context,
        dataBloc: dataBloc,
        useAction: value,
      );
    } else if ((value == UsePopupMenuEnum.ignore) ||
        (value == UsePopupMenuEnum.regard)) {
      dataBloc.setUseIgnored();
    }

    dataBloc.clearUseSelected();
  }

  onUsePopupMenuOpened({
    required BuildContext context,
    required UseModel use,
  }) {
    _log("onUsePopupMenuOpened").map("use", use).print();
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.selectUse(
      use: use,
    );
  }

  Future<void> showConfirmDialog(
      {required BuildContext context,
      required DataBloc dataBloc,
      required UsePopupMenuEnum useAction,
      bool showIgnore = false}) async {
    _log("showConfirmDialog").enum_("useAction", useAction).print();

    final l10n = AppLocalizations.of(
      context,
    )!;

    await showDialog(
      context: context,
      builder: (
        context,
      ) {
        final actionList = <Widget>[];

        final cancelButton = buildTextButton(
          label: l10n.cancel,
          onPressed: () => onDialogCancelPressed(
            context: context,
          ),
          align: showIgnore,
        );

        if (showIgnore) {
          actionList.add(
            buildRowForMultiChoice(
              child: cancelButton,
            ),
          );
        } else {
          actionList.add(
            cancelButton,
          );
        }

        if (showIgnore) {
          actionList.add(
            buildRowForMultiChoice(
              child: buildTextButton(
                label: dataBloc.useSelected!.isIgnored
                    ? l10n.menuRegardItem
                    : l10n.menuIgnoreItem,
                onPressed: () => onDialogIgnoreRegardPressed(
                  context: context,
                  dataBloc: dataBloc,
                ),
                align: true,
              ),
            ),
          );
        }

        final okButton = buildTextButton(
          label: l10n.ok,
          onPressed: () => onDialogOkPressed(
            context: context,
            useAction: useAction,
          ),
          align: showIgnore,
        );

        if (showIgnore) {
          actionList.add(
            buildRowForMultiChoice(
              child: okButton,
            ),
          );
        } else {
          actionList.add(
            okButton,
          );
        }

        return AlertDialog(
          content: Text(
            "${(useAction == UsePopupMenuEnum.remove) ? l10n.useRemoveString : l10n.useAddString} ${dataBloc.useSelected!.pieceOfClothing!.name}",
          ),
          actions: actionList,
        );
      },
    );
  }
}
