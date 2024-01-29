import 'package:core/core.dart';

import '../../../../domain/domain.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IGetWeatherUsecase _getWeatherUsecase;

  HomeBloc(this._getWeatherUsecase) : super(HomeInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(HomeEvent event, Emitter emit) async {
    if (event is SetInital) {
      await showData(emit);
    }
  }

  Future<void> showData(Emitter emit) async {
    emit(HomeLoadingState());
    final response = await _getWeatherUsecase('');

    final newState = response.fold(
      (failure) => HomeErrorState(),
      (weather) => HomeLoadedState(weather: weather),
    );

    emit(newState);
  }
}
