import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/app_bar_popup_menu.enum.dart';
import 'package:clothes_randomizer_app/dialogs.dart';
import 'package:clothes_randomizer_app/ui/widgets/theme_option.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AppBarPopupMenuWidget extends StatelessWidget {
  final List<PopupMenuItem<AppBarPopupMenuEnum>> Function({
    required AppLocalizations l10n,
  }) optionBuilder;

  factory AppBarPopupMenuWidget.signedIn() => AppBarPopupMenuWidget._(
        optionBuilder: ({
          required AppLocalizations l10n,
        }) =>
            [
          _buildItemReload(
            l10n: l10n,
          ),
          _buildItemTheme(
            l10n: l10n,
          ),
          _buildItemSignOut(
            l10n: l10n,
          ),
        ],
      );

  factory AppBarPopupMenuWidget.signedOut() => AppBarPopupMenuWidget._(
        optionBuilder: ({
          required AppLocalizations l10n,
        }) =>
            [
          _buildItemTheme(
            l10n: l10n,
          ),
        ],
      );

  const AppBarPopupMenuWidget._({
    required this.optionBuilder,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    return PopupMenuButton<AppBarPopupMenuEnum>(
      itemBuilder: (
        context,
      ) =>
          optionBuilder(
        l10n: l10n,
      ),
      onSelected: (
        value,
      ) =>
          onHomePopupMenuItemPressed(
        context: context,
        value: value,
      ),
    );
  }

  onHomePopupMenuItemPressed({
    required BuildContext context,
    required AppBarPopupMenuEnum value,
  }) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    switch (value) {
      case AppBarPopupMenuEnum.reload:
        final dataBloc = Provider.of<DataBloc>(
          context,
          listen: false,
        );
        dataBloc.revalidateData(
          refreshBaseData: true,
        );
        break;
      case AppBarPopupMenuEnum.theme:
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
      case AppBarPopupMenuEnum.signOut:
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

  static PopupMenuItem<AppBarPopupMenuEnum> _buildItem({
    required AppBarPopupMenuEnum enumValue,
    required String text,
  }) =>
      PopupMenuItem<AppBarPopupMenuEnum>(
        value: enumValue,
        child: Text(
          text,
        ),
      );

  static PopupMenuItem<AppBarPopupMenuEnum> _buildItemReload({
    required AppLocalizations l10n,
  }) =>
      _buildItem(
        enumValue: AppBarPopupMenuEnum.reload,
        text: l10n.reload,
      );

  static PopupMenuItem<AppBarPopupMenuEnum> _buildItemSignOut({
    required AppLocalizations l10n,
  }) =>
      _buildItem(
        enumValue: AppBarPopupMenuEnum.signOut,
        text: l10n.signOut,
      );

  static PopupMenuItem<AppBarPopupMenuEnum> _buildItemTheme({
    required AppLocalizations l10n,
  }) =>
      _buildItem(
        enumValue: AppBarPopupMenuEnum.theme,
        text: l10n.appTheme,
      );
}