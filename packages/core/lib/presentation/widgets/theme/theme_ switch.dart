import 'package:flutter/material.dart';

import '../../../core.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final providerTheme = Provider.of<ThemeFactory>(context);
    return InkWell(
      onTap: providerTheme.toogleTheme,
      child: providerTheme.theme == ThemeData.dark()
          ? Image.asset('assets/icons/day.png')
          : Image.asset('assets/icons/night.png'),
    );
  }
}
