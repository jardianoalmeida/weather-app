import 'package:flutter/material.dart';

import '../../../core.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final providerTheme = Provider.of<ThemeFactory>(context);

    return InkWell(
      onTap: providerTheme.toogleTheme,
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 1),
        firstChild: Image.asset('assets/icons/day.png'),
        secondChild: Image.asset('assets/icons/night.png'),
        crossFadeState: providerTheme.theme == ThemeData.dark()
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }
}
