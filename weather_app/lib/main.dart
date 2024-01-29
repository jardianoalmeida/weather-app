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
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ILocationAdapter>(
          create: (ctx) => LocationAdapter(),
        ),
        Provider<SplashBloc>(
          create: (ctx) => SplashBloc(ctx.read<ILocationAdapter>()),
        ),
        Provider<IHttpClient>(
          create: (ctx) => HttpAdapter(
            client: io.HttpClient(),
            baseUrl: 'http://api.weatherapi.com/',
            apiVersion: 'v1',
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
              final provider = Provider.of<ThemeFactory>(context);
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Weather App',
                theme: provider.theme,
                darkTheme: provider.theme,
                routerConfig: AppConfiguration.instance.router,
                locale: const Locale('pt', 'BR'),
              );
            },
          ),
        ),
      ),
    );
  }
}
