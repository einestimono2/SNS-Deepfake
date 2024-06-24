// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
      // if (await PermissionHelper.request([Permission.storage]) == false) {
      //   emit(const DownloadFailureState("Chưa cấp quyền để tải xuống!"));

      //   return;
      // }

      Directory? directory = await getDownloadDirectory();

      String? savePath = await FilesystemPicker.open(
        title: 'SELECT_SAVED_LOCATION'.tr(),
        context: event.context,
        rootDirectory: Directory('/storage/emulated/0'),
        directory: directory,
        fsType: FilesystemType.folder,
        pickText: 'SAVE_FILE_HERE'.tr(),
        contextActions: [
          FilesystemPickerNewFolderContextAction(),
        ],
        showGoUp: true,
      );

      if (savePath == null) return;

      emit(DownloadInProgressState());

      Response response = await dio.get(
        '/media/videos/${event.fileName}',
        options: Options(
          responseType: ResponseType.stream,
          headers: {'range': 'bytes=0-'},
          extra: cacheOptions.copyWith(policy: CachePolicy.noCache).toExtra(),
        ),
      );

      await downloadFile(response.data, savePath, event.fileName)
          .whenComplete(() => emit(DownloadSuccessfulState()))
          .onError((e, stackTrace) => emit(DownloadFailureState(e.toString())));
    } on DioException catch (e) {
      emit(DownloadFailureState(e.toString()));
    }
  }

  Future<Directory?> getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }

    return directory;
  }

  Future downloadFile(
    ResponseBody responseBody,
    String savePath,
    String fileName,
  ) async {
    final completer = Completer<void>();

    try {
      final file = File('$savePath/$fileName');
      final sink = file.openWrite();

      final stream = responseBody.stream;

      stream.listen(
        (data) => sink.add(data),
        onDone: () async {
          await sink.flush();
          await sink.close();
          completer.complete();
        },
        onError: (error) {
          completer.completeError(error);
        },
      );
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }
}
