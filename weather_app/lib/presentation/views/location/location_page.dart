import 'package:core/core.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  final bool isFromHome;
  const LocationPage({super.key, this.isFromHome = true});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late final TextEditingController cityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Dimension(context.mediaQuery.padding.top / 8).vertical,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isFromHome
                      ? BackButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.go('/home', extra: cityController.text);
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                  const ThemeSwitch(),
                ],
              ),
              Dimension.md.vertical,
              Row(
                children: [
                  Lottie.asset('assets/animations/pin.json', width: 30.0),
                  Dimension.xxs.horizontal,
                  const Text(
                    'Digite sua localidade',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Dimension.md.vertical,
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira algo';
                  }
                  return null;
                },
              ),
              Dimension.md.vertical,
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.go('/home', extra: cityController.text);
                    }
                  },
                  child: const Text(
                    'Avançar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cityController.clear();
    super.dispose();
  }
}
