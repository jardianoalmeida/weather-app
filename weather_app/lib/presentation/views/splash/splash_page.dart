import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../presentation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SplashBloc>(context)..add(SetSplash());
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeFactory>(context).loadData();
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is SplashLoadedState) {
            if (state.isAcceptPermission) {
              context.go('/home');
            } else {
              context.go('/location', extra: false);
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: .8,
              child: Image.asset(
                BaseAppAssets.logo.keyName,
              ).animate().fade().scale(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
