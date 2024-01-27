import 'package:core/core.dart';

import '../../../../domain/usecases/get_weather_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IGetWeatherUsecase _getWeatherUsecase;

  HomeBloc(this._getWeatherUsecase) : super(HomeInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(HomeEvent event, Emitter emit) async {
    if (event is SetInital) {
      emit(HomeLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await showData(emit);
    }
  }

  Future<void> showData(Emitter emit) async {
    final response = await _getWeatherUsecase('');

    final newState = response.fold(
      (l) => HomeLErrorState(),
      (r) => HomeLoadedState(weather: r),
    );

    emit(newState);
  }
}
