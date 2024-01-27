import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc.dart';

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
    BlocProvider.of<SplashBloc>(context).add(SetSplash());
    Provider.of<ThemeFactory>(context).loadData();
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoadedState) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: .8,
              child: Image.asset(
                'assets/images/splash_logo.jpg',
              ).animate().fade().scale(),
            ),
          );
        },
      ),
    );
  }
}
