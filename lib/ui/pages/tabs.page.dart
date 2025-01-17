import 'package:clothes_randomizer_app/blocs/entity.bloc.dart';
import 'package:clothes_randomizer_app/blocs/loading.bloc.dart';
import 'package:clothes_randomizer_app/blocs/user.bloc.dart';
import 'package:clothes_randomizer_app/constants/crud.enum.dart';
import 'package:clothes_randomizer_app/constants/state.enum.dart';
import 'package:clothes_randomizer_app/ui/pages/entity_read.page.dart';
import 'package:clothes_randomizer_app/ui/pages/entity_write.page.dart';
import 'package:clothes_randomizer_app/ui/pages/home.page.dart';
import 'package:clothes_randomizer_app/ui/pages/loading.page.dart';
import 'package:clothes_randomizer_app/ui/pages/sign_in.page.dart';
import 'package:clothes_randomizer_app/ui/pages/type_use.page.dart';
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
    final loadingBloc = Provider.of<LoadingBloc>(
      context,
    );
    final userBloc = Provider.of<UserBloc>(
      context,
    );
    final entityBloc = Provider.of<EntityBloc>(
      context,
    );

    if (loadingBloc.isLoading) {
      return const LoadingPage();
    } else if (userBloc.token != null) {
      return {
        StateUI.crud: () => {
              StateCRUD.create: () => const EntityWritePage(),
              StateCRUD.read: () => const EntityReadPage(),
              StateCRUD.update: () => const EntityWritePage(),
            }[entityBloc.state]!(),
        StateUI.home: () => const HomePage(),
        StateUI.link: () => const TypeUsePage(),
      }[userBloc.state]!();
    } else {
      return const SignInPage();
    }
  }
}
