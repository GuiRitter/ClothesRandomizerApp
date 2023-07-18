import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/home_popup_menu.enum.dart';
import 'package:clothes_randomizer_app/constants/use_popup_menu.enum.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/home/theme_option.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

    final theme = Theme.of(
      context,
    );

    final fieldPadding = theme.textTheme.labelLarge?.fontSize ?? 0.0;

    // final halfFieldPadding = fieldPadding / 2.0;
    final doubleFieldPadding = fieldPadding * 2.0;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.title,
        ),
        actions: [
          // TODO maybe add to other pages; investigate in Material Design the role of this button
          PopupMenuButton<HomePopupMenuEnum>(
            itemBuilder: (
              context,
            ) {
              return [
                PopupMenuItem<HomePopupMenuEnum>(
                  value: HomePopupMenuEnum.reload,
                  child: Text(
                    l10n.reload,
                  ),
                ),
                PopupMenuItem<HomePopupMenuEnum>(
                  value: HomePopupMenuEnum.theme,
                  child: Text(
                    l10n.appTheme,
                  ),
                ),
                PopupMenuItem<HomePopupMenuEnum>(
                  value: HomePopupMenuEnum.signOut,
                  child: Text(
                    l10n.signOut,
                  ),
                ),
              ];
            },
            onSelected: (
              value,
            ) =>
                onHomePopupMenuItemPressed(
              context: context,
              value: value,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
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
              DropdownButton<PieceOfClothingTypeModel>(
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
                          DropdownMenuItem<PieceOfClothingTypeModel>(
                        value: mPieceOfClothingType,
                        child: Text(
                          mPieceOfClothingType.name,
                        ),
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: doubleFieldPadding,
                ),
                child: Text(
                  l10n.selectLocationString,
                ),
              ),
              DropdownButton<LocalModel>(
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
              Padding(
                padding: EdgeInsets.only(
                  top: doubleFieldPadding,
                ),
                child: Text(
                  l10n.usesString,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dataBloc.useList.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final use = dataBloc.useList[index];

                    return ListTile(
                      title: Text(
                        use.pieceOfClothing!.name,
                      ),
                      subtitle: Text(
                        l10n.usesPlural(
                          use.counter,
                        ),
                      ),
                      trailing: PopupMenuButton<UsePopupMenuEnum>(
                        itemBuilder: (
                          context,
                        ) {
                          final List<PopupMenuItem<UsePopupMenuEnum>>
                              optionList = [
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
                              value: UsePopupMenuEnum.cancel,
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
              ElevatedButton(
                onPressed: () => onRandomPressed(
                  context: context,
                ),
                child: Text(
                  l10n.randomizeButtonString,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onDialogCancelPressed({
    required BuildContext context,
  }) =>
      Navigator.pop(
        context,
      );

  onDialogOkPressed({
    required BuildContext context,
  }) {}

  onHomePopupMenuItemPressed({
    required BuildContext context,
    required HomePopupMenuEnum value,
  }) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    switch (value) {
      case HomePopupMenuEnum.reload:
        final dataBloc = Provider.of<DataBloc>(
          context,
          listen: false,
        );
        dataBloc.revalidateData(
          refresh: true,
        );
        break;
      case HomePopupMenuEnum.theme:
        showDialog(
          context: context,
          builder: (
            context,
          ) =>
              AlertDialog(
            title: Text(
              l10n.chooseTheme,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ThemeOptionWidget(
                  themeMode: ThemeMode.dark,
                  title: l10n.darkTheme,
                ),
                ThemeOptionWidget(
                  themeMode: ThemeMode.light,
                  title: l10n.lightTheme,
                ),
                ThemeOptionWidget(
                  themeMode: ThemeMode.system,
                  title: l10n.systemTheme,
                ),
              ],
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
            ],
          ),
        );
        break;
      case HomePopupMenuEnum.signOut:
        final userBloc = Provider.of<UserBloc>(
          context,
          listen: false,
        );
        userBloc.validateAndSetToken(
          newToken: null,
        );
        break;
      default:
        break;
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
    final l10n = AppLocalizations.of(
      context,
    )!;

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );
    dataBloc.drawPieceOfClothing();

    await showDialog(
      context: context,
      builder: (
        context,
      ) =>
          AlertDialog(
        content: Text(
          "${l10n.useAddString} ${dataBloc.useSelected!.pieceOfClothing!.name}",
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

  onUsePopupMenuItemPressed({
    required BuildContext context,
    required UsePopupMenuEnum value,
  }) {
    // TODO
    // switch (value) {
    //   case HomePopupMenuEnum.reload:
    //     final dataBloc = Provider.of<DataBloc>(
    //       context,
    //       listen: false,
    //     );
    //     dataBloc.revalidateData(
    //       refresh: true,
    //     );
    //     break;
    //   case HomePopupMenuEnum.signOut:
    //     final userBloc = Provider.of<UserBloc>(
    //       context,
    //       listen: false,
    //     );
    //     userBloc.validateAndSetToken(
    //       newToken: null,
    //     );
    //     break;
    //   default:
    //     break;
    // }
  }
}
