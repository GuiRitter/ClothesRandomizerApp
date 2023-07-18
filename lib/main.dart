import 'dart:math';

import 'package:clothes_randomizer_app/blocs/data.bloc.dart';
import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/settings.dart';
import 'package:clothes_randomizer_app/ui/pages/tabs.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, themeMode, __) => MaterialApp(
          title: getTitle(
            context,
          ),
          theme: ThemeData().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
          ),
          themeMode: themeMode,
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
