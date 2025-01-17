import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/crud.enum.dart';
import 'package:clothes_randomizer_app/constants/state.enum.dart';
import 'package:clothes_randomizer_app/models/local.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/ui/widgets/type_and_local_drop_down.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_guiritter/util/logger.dart';
import 'package:provider/provider.dart';

final _log = logger("TypeUsePage");

class TypeUsePage extends StatelessWidget {
  const TypeUsePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    var l10n = AppLocalizations.of(
      context,
    )!;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    final theme = Theme.of(
      context,
    );

    final fieldPadding = theme.textTheme.labelLarge?.fontSize ?? 0.0;

    return Scaffold(
      appBar: appBarCustom(
        context: context,
        leading: BackButton(
          onPressed: () => onBackPressed(
            context: context,
          ),
        ),
        subtitle: l10n.linkLocalAndType,
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TypeAndLocalDropDown(
              isShowLocal: false,
            ),
            Expanded(
              child: ListView(
                children: [
                  ..._buildHeaderAndList(
                    header: l10n.linkedLocals,
                    fieldPadding: fieldPadding,
                    localModelList: dataBloc.localLinkedWithTypeList,
                    operation: StateCRUD.delete,
                    icon: Icons.link_off,
                  ),
                  const ListTile(),
                  ..._buildHeaderAndList(
                    header: l10n.notLinkedLocals,
                    fieldPadding: fieldPadding,
                    localModelList: dataBloc.localNotLinkedWithTypeList,
                    operation: StateCRUD.create,
                    icon: Icons.add_link,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onBackPressed({
    required BuildContext context,
  }) {
    _log("onBackPressed").print();

    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    userBloc.setState(
      state: StateUI.home,
      isNotify: true,
    );
  }

  updateLink({
    required StateCRUD operation,
    required BuildContext context,
    required LocalModel localModel,
  }) {
    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    dataBloc.updateLink(
      operation: operation,
      localModel: localModel,
    );
  }

  _buildHeaderAndList({
    required String header,
    required double fieldPadding,
    required List<LocalModel> localModelList,
    required StateCRUD operation,
    required IconData icon,
  }) =>
      [
        ListTile(
          title: Text(
            header,
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.only(
            left: fieldPadding,
          ),
          shrinkWrap: true,
          itemCount: localModelList.length,
          itemBuilder: (
            context,
            index,
          ) {
            final localModel = localModelList[index];

            return ListTile(
              onLongPress: () => updateLink(
                operation: operation,
                context: context,
                localModel: localModel,
              ),
              title: Text(
                localModel.name,
              ),
              trailing: IconButton(
                onPressed: () => updateLink(
                  operation: operation,
                  context: context,
                  localModel: localModel,
                ),
                icon: Icon(
                  icon,
                ),
              ),
            );
          },
        ),
      ];
}
