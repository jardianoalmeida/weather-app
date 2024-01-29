import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../presentation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashBloc>(context)..add(SetSplash());
    Provider.of<ThemeFactory>(context).loadData();
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoadedState) {
            if (state.isAcceptPermission) {
              context.go('/home');
            } else {
              context.go('/location');
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
}
