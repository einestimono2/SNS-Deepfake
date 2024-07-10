// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/utils/extensions/image_path.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final Dio dio;
  final CacheOptions cacheOptions;

  DownloadBloc({
    required this.dio,
    required this.cacheOptions,
  }) : super(DownloadInitialState()) {
    on<DownloadVideoSubmit>(_onDownloadVideoSubmit);
  }

  FutureOr<void> _onDownloadVideoSubmit(
    DownloadVideoSubmit event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      String? savePath = await FilePicker.platform.getDirectoryPath();
      if (savePath == null) return;

      final fileName = event.url.split('/').last;

      await dio.download(
        // '/media/videos/${event.fileName}',
        event.url.fullPath,
        "$savePath/$fileName",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            emit(DownloadInProgressState((received / total * 100).toInt()));
          }
        },
        options: Options(
          // responseType: ResponseType.bytes,
          // headers: {'range': 'bytes=0-'},
          followRedirects: false,
          extra: cacheOptions.copyWith(policy: CachePolicy.noCache).toExtra(),
        ),
      );

      emit(DownloadSuccessfulState());
    } on DioException catch (e) {
      emit(DownloadFailureState(e.toString()));
    }
  }
}
