import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

part 'deepfake_event.dart';
part 'deepfake_state.dart';

class DeepfakeBloc extends Bloc<DeepfakeEvent, DeepfakeState> {
  final CreateVideoDeepfakeUC createVideoDeepfakeUC;

  final MyPendingVideoDeepfakeBloc myPendingVideoDeepfakeBloc;

  DeepfakeBloc({
    required this.createVideoDeepfakeUC,
    required this.myPendingVideoDeepfakeBloc,
  }) : super(DeepfakeInitialState()) {
    on<CreateVideoDeepfakeSubmit>(_onCreateVideoDeepfakeSubmit);
  }

  FutureOr<void> _onCreateVideoDeepfakeSubmit(
    CreateVideoDeepfakeSubmit event,
    Emitter<DeepfakeState> emit,
  ) async {
    final result = await createVideoDeepfakeUC(
      CreateVideoDeepfakeParams(
        image: event.image,
        audios: event.audios ?? [],
        video: event.video,
        title: event.title,
      ),
    );

    result.fold(
      (l) => event.onError(l.toString()),
      (video) {
        myPendingVideoDeepfakeBloc.add(AddPendingVideo(video));

        event.onSuccess.call();
      },
    );
  }
}
