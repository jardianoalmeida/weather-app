import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'app_configuration.dart';
import 'data/datasources/remote/weather_datasource.dart';
import 'data/repositories/weather_repository.dart';
import 'domain/domain.dart';
import 'presentation/views/home/bloc/home_bloc.dart';
import 'presentation/views/splash/bloc/bloc.dart';

/// Build main app with correct flavor
Future<void> main() async {
  await AppConfiguration.instance.load();

  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SplashBloc>(
          create: (ctx) => SplashBloc(),
        ),
        Provider<IHttpClient>(
          create: (ctx) => HttpAdapter(
            client: io.HttpClient(),
            baseUrl: '',
          ),
        ),
        Provider<IWeatherDatasource>(
          create: (ctx) => WeatherDatasource(ctx.read<IHttpClient>()),
        ),
        Provider<IWeatherRepository>(
          create: (ctx) => WeatherRepository(ctx.read<IWeatherDatasource>()),
        ),
        Provider<IGetWeatherUsecase>(
          create: (ctx) => GetWeatherUsecase(ctx.read<IWeatherRepository>()),
        ),
        Provider<HomeBloc>(
          create: (ctx) => HomeBloc(ctx.read<IGetWeatherUsecase>()),
        ),
      ],
      child: CustomBanner(
        message: 'DEV',
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ChangeNotifierProvider(
            create: (context) => ThemeFactory(),
            builder: (context, child) {
              final provider = Provider.of<ThemeFactory>(context) ;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: Flavor.instance.getFlavor().title,
                theme: provider.theme,
                //  theme: AppThemeFactory.instance.currentLightTheme,
                // darkTheme: AppThemeFactory.instance.currentLightTheme,
                routerConfig: AppConfiguration.instance.router,
                //home: const SplashPage(),
                locale: const Locale('pt', 'BR'),
              );
            },
          ),
        ),
      ),
    );
  }
}
