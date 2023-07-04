import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/ui/pages/tabs.page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// flutter build web --base-href "/clothes_randomizer/"

void main() {
  runApp(
    const MyApp(),
  );
}

void showSnackBar({
  required String? message,
}) =>
    Settings.snackState.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message ?? "",
        ),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserBloc>.value(
            value: UserBloc(),
          ),
        ],
        child: MaterialApp(
          title: getTitle(
            context,
          ),
          theme: Theme.of(
            context,
          ).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
          ),
          // flutter gen-l10n
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scaffoldMessengerKey: Settings.snackState,
          home: const TabsPage(),
        ),
      );

  /// Only needed here
  getTitle(
    context,
  ) {
    var a = AppLocalizations.of(
      context,
    );
    return a?.title ?? "";
  }
}
