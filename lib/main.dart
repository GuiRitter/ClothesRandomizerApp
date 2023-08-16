import 'dart:math';

import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/constants/theme.enum.dart';
import 'package:clothes_randomizer_app/themes/dark.theme.dart';
import 'package:clothes_randomizer_app/themes/light.theme.dart';
import 'package:clothes_randomizer_app/themes/testDark.theme.dart';
import 'package:clothes_randomizer_app/themes/testlight.theme.dart';
import 'package:clothes_randomizer_app/ui/pages/tabs.page.dart';
import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = logger("MyApp");

// flutter build web --base-href "/clothes_randomizer/"

void main() {
  runApp(
    const MyApp(),
  );
}

void showSnackBar({
  required String? message,
}) {
  _log("showSnackBar").raw("message", message).print();

  Settings.snackState.currentState!.showSnackBar(
    SnackBar(
      content: Text(
        message ?? "",
      ),
    ),
  );
}

String treatDioResponse({
  required dynamic response,
}) {
  if (response!.data is Map) {
    if ((response!.data as Map).containsKey(
      Settings.error,
    )) {
      return response!.data[Settings.error];
    }
  }
  return response!.data.toString();
}

String treatException({
  required dynamic exception,
}) {
  if (exception is DioException) {
    if (exception.response != null) {
      return treatDioResponse(
        response: exception.response,
      );
    } else if (exception.message != null) {
      return exception.message!;
    }
  }
  return exception.toString();
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeEnum> themeNotifier = ValueNotifier(
    ThemeEnum.system,
  );

  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    SharedPreferences.getInstance().then(
      (
        prefs,
      ) {
        final themeName = prefs.getString(
          Settings.theme,
        );

        _log("build SharedPreferences.getInstance")
            .raw("theme", themeName)
            .print();

        if (themeName?.isNotEmpty ?? false) {
          var theme = ThemeEnum.values.byName(
            themeName!,
          );

          if ((!kDebugMode) && theme.isTest) {
            theme = theme.notTest;

            prefs.setString(
              Settings.theme,
              theme.name,
            );
          }

          themeNotifier.value = theme;
        }
      },
    );

    final testThemeLight = testLight(
      context: context,
    );

    final testThemeDark = testDark(
      context: context,
    );

    final themeLight = light(
      context: context,
    );

    final themeDark = dark(
      context: context,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingBloc>.value(
          value: LoadingBloc(),
        ),
        ChangeNotifierProvider<UserBloc>.value(
          value: UserBloc(),
        ),
        ChangeNotifierProvider<DataBloc>.value(
          value: DataBloc(),
        ),
        Provider<Random>.value(
          value: Random(),
        ),
      ],
      child: ValueListenableBuilder<ThemeEnum>(
        valueListenable: themeNotifier,
        builder: (
          _,
          themeMode,
          __,
        ) =>
            MaterialApp(
          title: getTitle(
            context,
          ),
          theme: (kDebugMode && (themeMode == ThemeEnum.testLight))
              ? testThemeLight
              : themeLight,
          darkTheme: (kDebugMode && (themeMode == ThemeEnum.testDark))
              ? testThemeDark
              : themeDark,
          themeMode: themeMode.mode,
          // flutter gen-l10n
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scaffoldMessengerKey: Settings.snackState,
          navigatorKey: Settings.navigatorState,
          home: const TabsPage(),
        ),
      ),
    );
  }

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
