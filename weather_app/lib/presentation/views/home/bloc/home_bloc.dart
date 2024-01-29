import 'package:core/core.dart';

import '../../../../domain/domain.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IGetWeatherUsecase _getWeatherUsecase;
  final ILocationAdapter _locationAdapter;

  HomeBloc(this._getWeatherUsecase, this._locationAdapter) : super(HomeInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(HomeEvent event, Emitter emit) async {
    if (event is SetInital) {
      await showData(emit, event.city);
    }
  }

  Future<void> showData(Emitter emit, String? city) async {
    emit(HomeLoadingState());

 

    final response = await _getWeatherUsecase(city ?? (await _locationAdapter.getLocation())!);

    final newState = response.fold(
      (failure) => HomeErrorState(),
      (weather) => HomeLoadedState(weather: weather),
    );

    emit(newState);
  }
}
