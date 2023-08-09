import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/use_popup_menu.enum.dart';
import 'package:clothes_randomizer_app/dialogs.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/use.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/dialog.widget.dart';
import 'package:clothes_randomizer_app/utils/date_time.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final _log = logger("UseWidget");

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
    dataBloc: dataBloc,
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

onRandomPressed({
  required BuildContext context,
  required DataBloc dataBloc,
}) async {
  _log("onRandomPressed").print();

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

class UseWidget extends StatefulWidget {
  final int index;

  const UseWidget({
    super.key,
    required this.index,
  });

  @override
  State<UseWidget> createState() => _UseWidgetState();
}

class _UseWidgetState extends State<UseWidget> {
  bool isHovering = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    final use = dataBloc.useList[widget.index];

    final l10n = AppLocalizations.of(
      context,
    )!;

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
          final List<PopupMenuItem<UsePopupMenuEnum>> optionList = [
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
                use.isIgnored ? l10n.menuRegardItem : l10n.menuIgnoreItem,
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
}
