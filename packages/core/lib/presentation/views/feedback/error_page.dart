import 'package:flutter/material.dart';

import '../../../core.dart';

class ErrorPage extends StatefulWidget {
  final VoidCallback onTryAgain;
  const ErrorPage({super.key, required this.onTryAgain});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimension.xl.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dimension(context.mediaQuery.padding.top / 8).vertical,
            const Align(
              alignment: Alignment.bottomRight,
              child: ThemeSwitch(),
            ),
            Dimension.md.vertical,
            const Dimension(10).vertical,
            const Spacer(),
            const Icon(
              Icons.error_outline_rounded,
              size: 54.0,
              color: Colors.red,
            ),
            Dimension.sm.vertical,
            const Text(
              'Ocorreu um erro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Dimension.sm.vertical,
            const Text(
              'Não foi possível exibir as informações no momento.',
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                  widget.onTryAgain.call();
                },
                child: const Text('Tentar novamente'),
              ),
            ),
            const Dimension(4).vertical,
          ],
        ),
      ),
    );
  }
}
