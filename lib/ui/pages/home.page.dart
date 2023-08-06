import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/sign.enum.dart';
import 'package:clothes_randomizer_app/dialogs.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/models/use.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_popup_menu.widget.dart';
import 'package:clothes_randomizer_app/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
                    title: Text(
                      use.pieceOfClothing!.name,
                    ),
                    subtitle: Text(
                      subtitle.join(
                        " ",
                      ),
                    ),
                    trailing: PopupMenuButton<SignEnum?>(
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
                        final List<PopupMenuItem<SignEnum>> optionList = [
                          PopupMenuItem<SignEnum>(
                            value: SignEnum.plus,
                            child: Text(
                              l10n.menuAddItem,
                            ),
                          ),
                        ];

                        if (use.counter > 0) {
                          optionList.add(
                            PopupMenuItem<SignEnum>(
                              value: SignEnum.minus,
                              child: Text(
                                l10n.menuRemoveItem,
                              ),
                            ),
                          );
                        }

                        optionList.add(
                          PopupMenuItem<SignEnum>(
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

  onDialogOkPressed({
    required BuildContext context,
    required SignEnum sign,
  }) async {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    onDialogCancelPressed(
      context: context,
    );

    final result = await dataBloc.updateUse(
      sign: sign,
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
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );
    final drawResult = await dataBloc.drawPieceOfClothing();

    if (drawResult.status != ResultStatus.success) {
      return;
    }

    if (context.mounted) {
      await showConfirmDialog(
        context: context,
        dataBloc: dataBloc,
        sign: SignEnum.plus,
      );
    }
  }

  onUsePopupMenuCanceled({
    required BuildContext context,
  }) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.clearUseSelected();
  }

  onUsePopupMenuItemPressed({
    required BuildContext context,
    required SignEnum? value,
  }) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    if (value == null) {
      return;
    }

    showConfirmDialog(
      context: context,
      dataBloc: dataBloc,
      sign: value,
    );
  }

  onUsePopupMenuOpened({
    required BuildContext context,
    required UseModel use,
  }) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.selectUse(
      use: use,
    );
  }

  Future<void> showConfirmDialog({
    required BuildContext context,
    required DataBloc dataBloc,
    required SignEnum sign,
  }) async {
    final l10n = AppLocalizations.of(
      context,
    )!;

    await showDialog(
      context: context,
      builder: (
        context,
      ) =>
          AlertDialog(
        content: Text(
          "${(sign == SignEnum.minus) ? l10n.useRemoveString : l10n.useAddString} ${dataBloc.useSelected!.pieceOfClothing!.name}",
        ),
        actions: [
          TextButton(
            onPressed: () => onDialogCancelPressed(
              context: context,
            ),
            child: Text(
              l10n.cancel,
              textAlign: TextAlign.end,
            ),
          ),
          TextButton(
            onPressed: () => onDialogOkPressed(
              context: context,
              sign: sign,
            ),
            child: Text(
              l10n.ok,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );

    dataBloc.clearUseSelected();
  }
}
