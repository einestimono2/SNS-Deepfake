part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadVideoSubmit extends DownloadEvent {
  final String fileName;
  final BuildContext context;

  const DownloadVideoSubmit({
    required this.fileName,
    required this.context,
  });

  @override
  List<Object> get props => [fileName];
}
