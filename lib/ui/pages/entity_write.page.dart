import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:clothes_randomizer_app/constants/entity.enum.dart';
import 'package:clothes_randomizer_app/constants/entity_column.enum.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/entity_column.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_custom.widget.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final _log = logger("EntityWritePage");

Widget _buildDropDown({
  required EntityColumnModel column,
  required String labelText,
  required EntityBloc entityBloc,
}) {
  _log("_buildDropDown")
      .map("column", column)
      .raw("labelText", labelText)
      .exists("entityBloc", entityBloc)
      .print();

  final itemList = entityBloc.entityListMap[column.type]!
      .map(
        (
          entity,
        ) =>
            DropdownMenuItem<String?>(
          value: entity[identityColumn],
          child: Text(
            column.getModel().getDescription(
                  entity,
                ),
          ),
        ),
      )
      .toList();

  return ListTile(
    title: InputDecorator(
      decoration: InputDecoration(
        border: InputBorder.none,
        label: Text(
          () {
            return labelText;
          }(),
        ),
      ),
      child: DropdownButton<String?>(
        value: entityBloc.entity[column.nameId],
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
        isExpanded: true,
        onChanged: (
          value,
        ) =>
            _onDropDownChanged(
          column: column,
          id: value,
          entityBloc: entityBloc,
        ),
        items: itemList,
      ),
    ),
  );
}

Widget _buildTextField({
  required EntityColumnModel column,
  required String labelText,
  required EntityBloc entityBloc,
}) {
  _log("_buildTextField")
      .map("column", column)
      .raw("labelText", labelText)
      .exists("entityBloc", entityBloc)
      .print();

  return ListTile(
    title: TextFormField(
      autofillHints: column.hints,
      decoration: InputDecoration(
        labelText: () {
          return labelText;
        }(),
      ),
      initialValue: entityBloc.entity[column.name],
      keyboardType: TextInputType.text,
      onChanged: (
        value,
      ) =>
          _onTextChanged(
        column: column,
        value: value,
        entityBloc: entityBloc,
      ),
    ),
  );
}

_onDropDownChanged({
  required EntityColumnModel column,
  required String? id,
  required EntityBloc entityBloc,
}) {
  _log("_onDropDownChanged")
      .map("column", column)
      .raw("id", id)
      .exists("entityBloc", entityBloc)
      .print();

  entityBloc.setColumnValue(
    column: column,
    id: id,
    isNotify: true,
  );
}

void _onSavePressed({
  required EntityBloc entityBloc,
}) async {
  _log("_onSavePressed").exists("entityBloc", entityBloc).print();

  final result = await entityBloc.createEntity();

  if (result.hasMessageNotIn(
    status: ResultStatus.success,
  )) {
    showSnackBar(
      message: result.message,
    );
  }
}

_onTextChanged({
  required EntityColumnModel column,
  required String? value,
  required EntityBloc entityBloc,
}) {
  _log("_onDropDownChanged")
      .map("column", column)
      .raw("value", value)
      .exists("entityBloc", entityBloc)
      .print();

  entityBloc.setColumnValue(
    column: column,
    value: value,
    isNotify: false,
  );
}

class EntityWritePage extends StatelessWidget {
  const EntityWritePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final entityBloc = Provider.of<EntityBloc>(
      context,
    );

    final entityBlocAnon = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    final theme = Theme.of(
      context,
    );

    final fieldPadding = theme.textTheme.labelLarge?.fontSize ?? 0.0;

    final widgetList = entityBloc.entityTemplate!.columnDisplayList
        .map(
          (
            mColumn,
          ) =>
              _widgetByEntityColumnModel(
            entity: entityBloc.entityTemplate!,
            column: mColumn,
            l10n: l10n,
            entityBloc: entityBlocAnon,
          ),
        )
        .toList();

    widgetList.add(
      ElevatedButton(
        onPressed: () => _onSavePressed(
          entityBloc: entityBlocAnon,
        ),
        child: Text(
          l10n.save,
        ),
      ),
    );

    return Scaffold(
      appBar: appBarCustom(
        context: context,
        leading: BackButton(
          onPressed: () => onBackPressed(
            context: context,
          ),
        ),
        subtitle: "${l10n.createEntity}${l10n.entityName(
          entityBloc.entityTemplate!.entityName,
        )}",
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(
            fieldPadding,
          ),
          child: ListView.separated(
            itemCount: widgetList.length,
            separatorBuilder: (
              context,
              index,
            ) =>
                SizedBox.square(
              dimension: fieldPadding,
            ),
            itemBuilder: (
              context,
              index,
            ) =>
                widgetList[index],
          ),
        ),
      ),
    );
  }

  onBackPressed({
    required BuildContext context,
  }) {
    _log("onBackPressed").exists("context", context).print();

    final entityBloc = Provider.of<EntityBloc>(
      context,
      listen: false,
    );

    entityBloc.manageEntity(
      entityModel: entityBloc.entityTemplate!,
    );
  }

  Widget _widgetByEntityColumnModel({
    required EntityModel entity,
    required EntityColumnModel column,
    required AppLocalizations l10n,
    required EntityBloc entityBloc,
  }) {
    _log("_widgetByEntityColumnModel")
        .enum_("entity", entity)
        .map("column", column)
        .exists("l10n", l10n)
        .exists("entityBloc", entityBloc)
        .print();

    final labelText = l10n.entityHeader(
      "${entity.entityName}__${column.name}",
    );

    return {
      EntityColumnKind.entitySingle: _buildDropDown,
      EntityColumnKind.text: _buildTextField,
    }[column.kind]!(
      column: column,
      labelText: labelText,
      entityBloc: entityBloc,
    );
  }
}
