import 'package:core/core.dart';

import '../splash.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ILocationAdapter _locationAdapter;
  SplashBloc(this._locationAdapter) : super(SplashInitialState()) {
    on((event, emit) async {
      if (event is SetSplash) {
        await checkLocationPermission(emit);
      }
    });
  }

  Future<void> checkLocationPermission(Emitter emit) async {
    emit(SplashLoadingState());
    final granted = await _locationAdapter.checkLocationPermission();

    // Delay a bit to show the splash screen for a while
    await Future.delayed(const Duration(seconds: 3));

    emit(SplashLoadedState(isAcceptPermission: granted));
  }
}
