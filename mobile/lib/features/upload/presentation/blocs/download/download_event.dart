part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadVideoSubmit extends DownloadEvent {
  final String url;
  final BuildContext context;

  const DownloadVideoSubmit({
    required this.url,
    required this.context,
  });

  @override
  List<Object> get props => [url];
}
