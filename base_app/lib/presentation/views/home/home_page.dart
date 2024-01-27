import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc.dart';
import 'day_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // locationBuilder();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeBloc>()..add(SetInital());
    return Center(
      child: Scaffold(
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: bloc,
          listener: (context, state) {},
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
                          onTap: () => context.go('/location'),
                          child: Row(
                            children: [
                              Image.asset('assets/images/place_marker.png'),
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
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        '${state.weather?.tempCurrent}°',
                        style: const TextStyle(
                          fontSize: 200,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Tempo limpo.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${state.weather?.current.minTemp}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                          '${state.weather?.current.maxTemp}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(
                      color: Color(0xffEDF0F2),
                      thickness: 2,
                    ),
                    const Spacer(),
                    const Text(
                      'Previsão para os próximos dias',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    ...state.weather!.forecastDays.map((e) => DayTile(forecast: e)).toList(),
                    const Spacer(),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
