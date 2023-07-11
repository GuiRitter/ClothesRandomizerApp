import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/popup_menu.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                onSignOut(
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
                onChanged: onPieceOfClothingTypeChanged,
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
              FutureBuilder(
                future: dataBloc.localList,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.hasData) {
                    return DropdownButton<LocalModel>(
                      value: dataBloc.localSelected,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      isExpanded: true,
                      onChanged: onLocalChanged,
                      items: (snapshot.data as List<LocalModel>)
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
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.getBaseData().then(
      (
        result,
      ) {
        if (result.hasMessageNotIn(
          status: ResultStatus.success,
        )) {
          showSnackBar(
            message: result.message,
          );
        }
      },
    );

    super.initState();
  }

  onLocalChanged(
    LocalModel? value,
  ) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.localSelected = value;
  }

  onPieceOfClothingTypeChanged(
    PieceOfClothingTypeModel? value,
  ) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.pieceOfClothingTypeSelected = value;
  }

  onSignOut({
    required BuildContext context,
    required PopupMenuEnum value,
  }) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    userBloc.validateAndSetToken(newToken: null);
  }
}
