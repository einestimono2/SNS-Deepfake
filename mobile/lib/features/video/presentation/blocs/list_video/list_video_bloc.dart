import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/utils/utils.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'list_video_event.dart';
part 'list_video_state.dart';

class ListVideoBloc extends Bloc<ListVideoEvent, ListVideoState> {
  final GetListVideoUC getListVideoUC;

  ListVideoBloc({
    required this.getListVideoUC,
  }) : super(const ListVideoState()) {
    on<GetListVideo>(_onGetListVideo);
    on<LoadMoreListVideo>(_onLoadMoreListVideo);
    on<VideoIndexChanged>(_onVideoIndexChanged);
  }

  FutureOr<void> _onGetListVideo(
    GetListVideo event,
    Emitter<ListVideoState> emit,
  ) async {
    final result = await getListVideoUC(GetListVideoParams(
      page: 1,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMsg: failure.toString())),
      (response) async {
        emit(state.copyWith(
          videos: [...state.videos, ...response.data],
          currentPage: state.currentPage + 1,
          controllers: {},
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
        ));

        /// Initialize 1st video
        await _initializeControllerAtIndex(0);

        /// Play 1st video
        // _playControllerAtIndex(0);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1);
      },
    );
  }

  FutureOr<void> _onVideoIndexChanged(
    VideoIndexChanged event,
    Emitter<ListVideoState> emit,
  ) async {
    /// Check to fetch new videos
    final bool shouldFetch = !state.hasReachedMax &&
        (event.index + AppStrings.kPreloadLimit) %
                AppStrings.listVideoPageSize ==
            0 &&
        state.videos.length == event.index + AppStrings.kPreloadLimit;

    if (shouldFetch) {
      add(const LoadMoreListVideo(size: AppStrings.listVideoPageSize));
    }

    /// Next / Prev video decider
    if (event.index > state.currentIndex) {
      _playNext(event.index);
    } else {
      _playPrevious(event.index);
    }

    emit(state.copyWith(currentIndex: event.index));
  }

  FutureOr<void> _onLoadMoreListVideo(
    LoadMoreListVideo event,
    Emitter<ListVideoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getListVideoUC(GetListVideoParams(
      page: state.currentPage + 1,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        errorMsg: failure.toString(),
        isLoading: false,
      )),
      (response) async {
        emit(state.copyWith(
          videos: [...state.videos, ...response.data],
          currentPage: state.currentPage + 1,
          isLoading: false,
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
        ));

        /// Initialize new url
        _initializeControllerAtIndex(state.currentIndex + 1);
      },
    );
  }

  /* ========================================================= */

  /// ===> Sử dụng tại hàm main
  /// Isolate to fetch videos in the background so that the video experience is not disturbed.
  /// Without isolate, the video will be paused whenever there is an API call
  /// because the main thread will be busy fetching new video URLs.
  // Future createIsolate(int index) async {
  //   // Set loading to true
  //   add(SetLoading());

  //   ReceivePort mainReceivePort = ReceivePort();

  //   await Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  //   mainReceivePort.listen((message) {
  //     //listening data from isolate
  //     print(message);
  //   });

  //   // SendPort isolateSendPort = await mainReceivePort.first;

  //   // ReceivePort isolateResponseReceivePort = ReceivePort();

  //   // isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  //   // final isolateResponse = await isolateResponseReceivePort.first;
  //   // final _videos = isolateResponse;

  //   // // Update new result
  //   // add(UpdateListVideo(_videos));
  // }

  // void getVideosTask(SendPort mySendPort) async {
  //   final result = await getListVideoUC(GetListVideoParams(
  //     page: 2,
  //     size: 3,
  //     groupId: 0,
  //   ));

  //   result.fold(
  //     (failure) => print(failure.toString()),
  //     (response) => print(response.data),
  //   );

  //   // ReceivePort isolateReceivePort = ReceivePort();

  //   // mySendPort.send(isolateReceivePort.sendPort);
  //   // print("Call here");

  //   // await for (var message in isolateReceivePort) {
  //   //   if (message is List) {
  //   //     // final int index = message[0];

  //   //     // final SendPort isolateResponseSendPort = message[1];

  //   //     // final List<String> _urls =
  //   //     //     await ApiService.getVideos(id: index + kPreloadLimit);

  //   //     // isolateResponseSendPort.send(_urls);
  //   //     // TODO: HEREE
  //   //   }
  //   // }
  // }

  void _playNext(int index) {
    // Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    // Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    // Play current video (already initialized)
    _playControllerAtIndex(index);

    // Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    // Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    // Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    // Play current video (already initialized)
    _playControllerAtIndex(index);

    // Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (state.videos.length > index && index >= 0) {
      // Create new controller
      final _controller = VideoPlayerController.networkUrl(
        Uri.parse(state.videos[index].videos[0].url.fullPath),
        httpHeaders: {'range': 'bytes=0-'},
      );

      // Add to [controllers] list
      state.controllers[index] = _controller;

      // Initialize
      await _controller.initialize().onError((error, stackTrace) {
        AppLogger.error(error.toString(), error);
      });

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = state.controllers[index]!;

      /// Play controller
      _controller.play();

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = state.controllers[index]!;

      /// Pause
      _controller.pause();

      /// Reset postiton to beginning
      _controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.videos.length > index && index >= 0) {
      // Get controller at [index]
      final VideoPlayerController? _controller = state.controllers[index];

      // Dispose controller
      _controller?.dispose();

      if (_controller != null) {
        state.controllers.remove(index);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
  }
}
