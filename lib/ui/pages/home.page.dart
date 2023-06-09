import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/popup_menu.enum.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
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

    final fieldPadding = Theme.of(
          context,
        ).textTheme.labelLarge?.fontSize ??
        0.0;

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
          PopupMenuButton(
            itemBuilder: (
              context,
            ) {
              return [
                PopupMenuItem(
                  value: PopupMenuEnum.reload,
                  child: Text(
                    l10n.reload,
                  ),
                ),
                PopupMenuItem(
                  value: PopupMenuEnum.signOut,
                  child: Text(
                    l10n.signOut,
                  ),
                ),
              ];
            },
            onSelected: (
              value,
            ) =>
                onPopupMenuItemPressed(
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
                  ) =>
                      TextButton(
                    onPressed: () {},
                    onLongPress: () {},
                    child: ListTile(
                      title: Text(
                        dataBloc.useList[index].pieceOfClothing!.name,
                      ),
                      subtitle: Text(
                        l10n.usesPlural(
                          dataBloc.useList[index].counter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  onPopupMenuItemPressed({
    required BuildContext context,
    required PopupMenuEnum value,
  }) {
    switch (value) {
      case PopupMenuEnum.reload:
        final dataBloc = Provider.of<DataBloc>(
          context,
          listen: false,
        );
        dataBloc.revalidateData(
          refresh: true,
        );
        break;
      case PopupMenuEnum.signOut:
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
}
