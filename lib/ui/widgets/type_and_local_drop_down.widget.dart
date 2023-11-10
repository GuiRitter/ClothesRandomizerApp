import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/models/piece_of_clothing_type.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final GlobalKey localDropDownKey = GlobalKey();

final _log = logger("LocalAndTypeDropDown");

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

class TypeAndLocalDropDown extends StatelessWidget {
  final bool isShowLocal;

  const TypeAndLocalDropDown({
    super.key,
    required this.isShowLocal,
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

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    final children = <Widget>[
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
                    DropdownMenuItem<PieceOfClothingTypeModel>(
                  value: mPieceOfClothingType,
                  child: Text(
                    mPieceOfClothingType.name,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ];

    if (isShowLocal) {
      children.addAll(
        [
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
      );
    }

    return FutureBuilder<double>(
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
                children: children,
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
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
