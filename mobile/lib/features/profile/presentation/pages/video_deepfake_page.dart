import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/play_video_dialog.dart';

class VideoDeepfakePage extends StatefulWidget {
  const VideoDeepfakePage({super.key});

  @override
  State<VideoDeepfakePage> createState() => _VideoDeepfakePageState();
}

class _VideoDeepfakePageState extends State<VideoDeepfakePage> {
  int _pendingPage = 1;
  bool _pendingLoadingMore = false;
  bool _pendingHasReachedMax = false;

  late final _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    _getPendingVideos();

    if (context.read<MyVideoDeepfakeBloc>().state
        is! MyVideoDeepfakeSuccessfulState) {
      _getMyVideos();
    }

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _pendingScrollListener() {
    if (!_pendingLoadingMore && !_pendingHasReachedMax) {
      _pendingLoadingMore = true;

      context.read<MyPendingVideoDeepfakeBloc>().add(
            LoadMoreMyPendingVideoDeepfakes(
              page: ++_pendingPage,
              size: AppStrings.pendingDeepfakePageSize,
            ),
          );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<MyVideoDeepfakeBloc>().add(LoadMoreMyVideoDeepfakes(
            page: ++_page,
            size: AppStrings.videoDeepfakePageSize,
          ));
    }
  }

  void _getPendingVideos() {
    context
        .read<MyPendingVideoDeepfakeBloc>()
        .add(const GetMyPendingVideoDeepfakes(
          page: 1,
          size: AppStrings.pendingDeepfakePageSize,
        ));
  }

  void _getMyVideos() {
    context.read<MyVideoDeepfakeBloc>().add(const GetMyVideoDeepfakes(
          page: 1,
          size: AppStrings.videoDeepfakePageSize,
        ));
  }

  void _handlePlay(String url) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => PlayVideoDialog(url: url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      controller: _scrollController,
      onRefresh: () async {
        _getMyVideos();
        _getPendingVideos();
      },
      title: "Deepfake",
      slivers: [
        SliverToBoxAdapter(
          child: SectionTitle(
            title: "PENDING_VIDEO_TEXT".tr(),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 0.35.sh,
            width: double.infinity,
            alignment: Alignment.center,
            child: _buidPendingVideo(),
          ),
        ),

        /*  */
        SliverToBoxAdapter(
          child: SectionTitle(
            title: "MY_VIDEO_TEXT".tr(),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          ),
        ),
        SliverToBoxAdapter(child: _buidMyVideos()),
      ],
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(Routes.mySchedule.name),
          icon: const Icon(FontAwesomeIcons.clipboardList, size: 18),
        ),
        IconButton(
          onPressed: () => context.goNamed(Routes.createVideoDF.name),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buidPendingVideo() {
    return BlocBuilder<MyPendingVideoDeepfakeBloc, MyPendingVideoDeepfakeState>(
      builder: (context, state) {
        if (state is MyPendingVideoDeepfakeInProgressState ||
            state is MyPendingVideoDeepfakeInitialState) {
          return const AppIndicator();
        } else if (state is MyPendingVideoDeepfakeSuccessfulState) {
          _pendingLoadingMore = false;
          _pendingHasReachedMax = state.hasReachedMax;

          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.hasReachedMax
                  ? state.videos.length
                  : state.videos.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.videos.length) {
                  return IconButton(
                    onPressed: _pendingScrollListener,
                    icon: const Icon(Icons.label_important_rounded),
                  );
                }

                return InkWell(
                  onTap: () => _handlePlay(state.videos[index].url),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 0.3.sh,
                        height: 0.3.sh,
                        child: AppVideo(
                          state.videos[index].url.fullPath,
                          isNetwork: true,
                          onlyShowThumbnail: true,
                        ),
                      ),
                      Text(
                        state.videos[index].title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return ErrorCard(
            onRefresh: _getPendingVideos,
            message: (state as MyPendingVideoDeepfakeFailureState).message,
          );
        }
      },
    );
  }

  Widget _buidMyVideos() {
    return BlocBuilder<MyVideoDeepfakeBloc, MyVideoDeepfakeState>(
      builder: (context, state) {
        if (state is MyVideoDeepfakeInProgressState ||
            state is MyVideoDeepfakeInitialState) {
          return Container(
            width: double.infinity,
            height: 0.35.sh,
            alignment: Alignment.center,
            child: const AppIndicator(),
          );
        } else if (state is MyVideoDeepfakeSuccessfulState) {
          _loadingMore = false;
          _hasReachedMax = state.hasReachedMax;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            shrinkWrap: true,
            itemCount: state.hasReachedMax
                ? state.videos.length
                : state.videos.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.videos.length) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(child: AppIndicator(size: 32)),
                );
              }

              return InkWell(
                onTap: () => _handlePlay(state.videos[index].url),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 0.25.sw,
                      height: 0.25.sw,
                      child: AppVideo(
                        state.videos[index].url.fullPath,
                        isNetwork: true,
                        onlyShowThumbnail: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.videos[index].title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.pushNamed(
                        Routes.scheduleVideo.name,
                        extra: {"videoId": state.videos[index].id},
                      ),
                      icon: const Icon(FontAwesomeIcons.calendarPlus, size: 18),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return ErrorCard(
            onRefresh: _getMyVideos,
            message: (state as MyVideoDeepfakeFailureState).message,
          );
        }
      },
    );
  }
}
