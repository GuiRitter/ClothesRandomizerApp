import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/ui/pages/home.page.dart';
import 'package:clothes_randomizer_app/ui/pages/loading.page.dart';
import 'package:clothes_randomizer_app/ui/pages/sign_in.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final userBloc = Provider.of<UserBloc>(
      context,
    );

    if (userBloc.isLoading) {
      return const LoadingPage();
    } else if (userBloc.token != null) {
      return const HomePage();
    } else {
      return SignInPage();
    }
  }
}
