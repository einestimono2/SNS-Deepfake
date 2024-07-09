part of 'list_video_bloc.dart';

class ListVideoState extends Equatable {
  final List<VideoModel> videos;
  final Map<int, VideoPlayerController> controllers;
  final bool hasReachedMax;
  final int totalCount;
  final bool isLoading;
  final int currentIndex;
  final int currentPage;
  final String? errorMsg;
  final bool isInitState;

  const ListVideoState({
    this.videos = const [],
    this.controllers = const {},
    this.hasReachedMax = true,
    this.totalCount = 0,
    this.isLoading = false,
    this.currentIndex = 0,
    this.currentPage = 0,
    this.errorMsg,
    this.isInitState = true,
  });

  @override
  List<Object?> get props => [
        videos,
        controllers,
        hasReachedMax,
        totalCount,
        isLoading,
        currentIndex,
        currentPage,
        errorMsg,
      ];

  ListVideoState copyWith({
    List<VideoModel>? videos,
    Map<int, VideoPlayerController>? controllers,
    bool? hasReachedMax,
    int? totalCount,
    bool? isLoading,
    int? currentIndex,
    int? currentPage,
    String? errorMsg,
  }) =>
      ListVideoState(
        videos: videos ?? this.videos,
        controllers: controllers ?? this.controllers,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        totalCount: totalCount ?? this.totalCount,
        isLoading: isLoading ?? this.isLoading,
        currentIndex: currentIndex ?? this.currentIndex,
        currentPage: currentPage ?? this.currentPage,
        errorMsg: errorMsg,
        isInitState: false,
      );
}
