import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[BLOC EVENT] ${bloc.runtimeType}: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error('${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // log(
    //   '[BLOC TRANSITION] ${transition.currentState} --> ${transition.nextState}',
    // );
  }
}
