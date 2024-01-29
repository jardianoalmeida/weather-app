import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../presentation.dart';

class HomePage extends StatefulWidget {
  final String? cityArgument;
  const HomePage({super.key, this.cityArgument});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeBloc>(context)..add(SetInital(city: widget.cityArgument));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is HomeErrorState) {
            context.pushNamed(
              '/error',
              extra: () => _bloc.add(SetInital(city: widget.cityArgument)),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HomeLoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Dimension(context.mediaQuery.padding.top / 8).vertical,
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: ThemeSwitch(),
                  ),
                  Dimension.md.vertical,
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.goNamed('/location', extra: true),
                        child: Row(
                          children: [
                            Lottie.asset('assets/animations/pin.json', width: 30.0),
                            Dimension.xxs.horizontal,
                            Text(
                              state.weather!.location,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Image.network(
                        state.weather!.current.status.image,
                        height: 30.0,
                      ),
                      Dimension.xxs.horizontal,
                      Text(
                        state.weather?.current.status.description ?? '',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Dimension.xl.vertical,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.now().dayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Dimension.md.horizontal,
                      Container(
                        width: 52,
                        height: 4.0,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      Dimension.md.horizontal,
                      Text(
                        DateTime.now().format('d MMM.'),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${state.weather?.tempCurrent}°',
                      style: const TextStyle(
                        fontSize: 200.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fade().scale(),
                  ),
                  Row(
                    children: [
                      Text(
                        'Máx.: ${state.weather?.current.minTemp}°',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Dimension.md.horizontal,
                      Center(
                        child: Container(
                          width: 52,
                          height: 4.0,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      Dimension.md.horizontal,
                      Text(
                        'Mín.: ${state.weather?.current.maxTemp}°',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Divider(
                    color: Theme.of(context).primaryColorLight,
                    thickness: 2,
                  ),
                  const Spacer(),
                  const Text(
                    'Previsão para os próximos dias',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const Spacer(),
                  ...state.weather!.forecastDays.map((e) => DayTile(forecast: e)),
                  const Spacer(),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
