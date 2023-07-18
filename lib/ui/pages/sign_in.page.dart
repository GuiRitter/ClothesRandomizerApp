import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/result_status.enum.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/main.dart';
import 'package:clothes_randomizer_app/models/sign_in.model.dart';
import 'package:clothes_randomizer_app/ui/widgets/app_bar_popup_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  String? _userId;
  String? _password;

  @override
  Widget build(
    BuildContext context,
  ) {
    final userBloc = Provider.of<UserBloc>(
      context,
    );

    final dataBloc = Provider.of<DataBloc>(
      context,
    );

    var l10n = AppLocalizations.of(
      context,
    )!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            context,
          )!
              .title,
        ),
        actions: [
          AppBarPopupMenuWidget.signedOut(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            Theme.of(
                  context,
                ).textTheme.titleLarge?.fontSize ??
                0,
          ),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    autofillHints: const [
                      AutofillHints.username,
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.userID,
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (
                      input,
                    ) =>
                        _userId = input,
                    validator: (
                      value,
                    ) =>
                        (value?.isEmpty ?? true) ? l10n.invalidUserID : null,
                  ),
                  TextFormField(
                    autofillHints: const [
                      AutofillHints.password,
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.password,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSaved: (
                      input,
                    ) =>
                        _password = input,
                    validator: (
                      value,
                    ) =>
                        (value?.isEmpty ?? true) ? l10n.invalidPassword : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Theme.of(
                            context,
                          ).textTheme.titleLarge?.fontSize ??
                          0,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        _formKey.currentState?.save();

                        TextInput.finishAutofillContext();

                        final result = await userBloc.signIn(
                          SignInModel(
                            userId: _userId ?? "",
                            password: _password ?? "",
                          ),
                        );

                        if (result.hasMessageNotIn(
                          status: ResultStatus.success,
                        )) {
                          showSnackBar(
                            message: result.message,
                          );
                        } else {
                          dataBloc.revalidateData(
                            refresh: true,
                          );
                        }
                      },
                      child: Text(
                        l10n.signIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    final dataBloc = Provider.of<DataBloc>(
      context,
      listen: false,
    );

    SharedPreferences.getInstance().then(
      (
        prefs,
      ) {
        var token = prefs.getString(
          Settings.token,
        );
        if (token?.isNotEmpty ?? false) {
          userBloc
              .validateAndSetToken(
            newToken: token,
          )
              .then(
            (
              result,
            ) {
              if (result.hasMessageNotIn(
                status: ResultStatus.success,
              )) {
                showSnackBar(
                  message: result.message,
                );
              } else {
                dataBloc.revalidateData(
                  refresh: true,
                );
              }
            },
          );
        }
      },
    );

    super.initState();
  }
}
