// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/libs/libs.dart';
import 'package:sns_deepfake/features/upload/presentation/presentation.dart';
import 'package:sns_deepfake/features/video/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/video/presentation/widgets/modal_comment.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../upload/upload.dart';
import '../../data/data.dart';

class VideoWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final VideoModel video;
  final bool isFirstVideo;

  const VideoWidget({
    super.key,
    required this.controller,
    required this.video,
    this.isFirstVideo = false,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late int myId;

  final ValueNotifier<bool> _pause = ValueNotifier(false);
  late final ValueNotifier<Map<String, dynamic>> _status;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;
    _status = ValueNotifier({
      "feel": widget.video.myFeel,
      "kudos": widget.video.kudosCount,
      "disappointed": widget.video.disappointedCount,
      "fakes": widget.video.fakeCount,
      "trusts": widget.video.trustCount,
    });

    super.initState();

    widget.controller.setLooping(true);

    if (widget.isFirstVideo) {
      WidgetsBinding.instance.addPostFrameCallback((call) {
        if (mounted) {
          widget.controller.seekTo(Duration.zero).then(
                (value) => widget.controller.play(),
              );
        }
      });
    }
  }

  void _handleDownload() async {
    _handlePause();

    context.read<DownloadBloc>().add(DownloadVideoSubmit(
          url: widget.video.videos[0].url,
          context: context,
        ));
  }

  void _handleNavProfile() {
    _handlePause();

    if (widget.video.authorId == myId) {
      context.pushNamed(Routes.myProfile.name);
    } else {
      context.pushNamed(
        Routes.otherProfile.name,
        pathParameters: {"id": widget.video.authorId.toString()},
        extra: {'username': widget.video.author.username},
      );
    }
  }

  void _handlePause() {
    widget.controller.pause();
    _pause.value = true;
  }

  void _handleResume() {
    widget.controller.play();
    _pause.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*  */
        Expanded(
          child: widget.controller.value.hasError
              ? Center(
                  child: SizedBox(
                    height: 0.35.sh,
                    width: double.infinity,
                    child: const LocalImage(path: AppImages.brokenImage),
                  ),
                )
              : GestureDetector(
                  onTap: _handlePause,
                  child: VideoPlayer(widget.controller),
                ),
        ),

        /*  */
        ValueListenableBuilder(
          valueListenable: _pause,
          builder: (context, value, child) {
            return value
                ? Expanded(
                    child: GestureDetector(
                      onTap: _handleResume,
                      child: Center(
                        child: Icon(Icons.play_arrow, size: 0.3.sw),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),

        /*  */
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 12, bottom: 16),
                    child: _bottomPanel(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0.2.sw,
              child: _rightPanel(),
            ),
          ],
        ),

        /*  */
        Align(
          alignment: Alignment.bottomCenter,
          child: VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            padding: EdgeInsets.zero,
            colors: const VideoProgressColors(
              backgroundColor: Colors.white,
              playedColor: AppColors.kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*  */
        Row(
          children: [
            GestureDetector(
              onTap: _handleNavProfile,
              child: Text(
                widget.video.author.username ?? widget.video.author.email,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "\u00b7",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 6),
            Text(
              DateHelper.getTimeAgo(
                widget.video.createdAt,
                context.locale.languageCode,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),

        /*  */
        const SizedBox(height: 6),
        if (widget.video.description?.isNotEmpty ?? false)
          ReadMoreText(
            widget.video.description!,
            trimLines: 3,
            trimMode: TrimMode.line,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 13.sp),
          ),

        /*  */
        if (widget.video.group != null) const SizedBox(height: 16),
        if (widget.video.group != null)
          GestureDetector(
            onTap: () => context.pushNamed(
              Routes.groupDetails.name,
              pathParameters: {"id": widget.video.group!.id.toString()},
              extra: {
                "coverPhoto": widget.video.group!.coverPhoto,
                "groupName": widget.video.group!.groupName,
              },
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedImage(
                  url: widget.video.group!.coverPhoto?.fullPath ?? "",
                  radius: 6,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.video.group!.groupName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _rightPanel() {
    return ValueListenableBuilder(
      valueListenable: _status,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _handleNavProfile,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kPrimaryColor, width: 3),
              ),
              child: AnimatedImage(
                url: widget.video.author.avatar?.fullPath ?? "",
                isAvatar: true,
                width: 0.125.sw,
                height: 0.125.sw,
              ),
            ),
          ),
          SizedBox(height: 0.035.sh),
          InkWell(
            child: Column(
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 36,
                  color: value["feel"] == 0 ? AppColors.kPrimaryColor : null,
                ),
                value["kudos"] > 0
                    ? Text(
                        Formatter.formatShortenNumber(
                          value["kudos"].toDouble(),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      )
                    : SizedBox(height: 14.sp),
              ],
            ),
            onTap: () => context.read<ListVideoBloc>().add(UpdateMyFeel(
                  feel: value["feel"] == 0 ? -1 : 0,
                  videoId: widget.video.id,
                  onSuccess: (feel, kudos, disappointed) {
                    _status.value = {
                      "feel": feel,
                      "kudos": kudos,
                      "disappointed": disappointed,
                    };
                  },
                  onError: (msg) => context.showError(message: msg),
                )),
          ),
          SizedBox(height: 0.015.sh),
          InkWell(
            child: Column(
              children: [
                Icon(
                  Icons.thumb_down,
                  size: 36,
                  color: value["feel"] == 1 ? AppColors.kPrimaryColor : null,
                ),
                value["disappointed"] > 0
                    ? Text(
                        Formatter.formatShortenNumber(
                          value["disappointed"].toDouble(),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      )
                    : SizedBox(height: 14.sp),
              ],
            ),
            onTap: () => context.read<ListVideoBloc>().add(UpdateMyFeel(
                  feel: value["feel"] == 1 ? -1 : 1,
                  videoId: widget.video.id,
                  onSuccess: (feel, kudos, disappointed) {
                    _status.value = {
                      "feel": feel,
                      "kudos": kudos,
                      "disappointed": disappointed,
                      "fakes": _status.value["fakes"],
                      "trusts": _status.value["trusts"],
                    };
                  },
                  onError: (msg) => context.showError(message: msg),
                )),
          ),
          SizedBox(height: 0.015.sh),
          InkWell(
            child: Column(
              children: [
                const Icon(FontAwesomeIcons.solidComment, size: 36),
                value["fakes"] + value["trusts"] > 0
                    ? Text(
                        Formatter.formatShortenNumber(
                          (widget.video.trustCount + widget.video.fakeCount)
                              .toDouble(),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      )
                    : SizedBox(height: 14.sp),
              ],
            ),
            onTap: () {
              _handlePause();

              openModalBottomSheet(
                context: context,
                useRootNavigator: true,
                child: ModalComment(
                  video: widget.video,
                  onComment: (fakes, trusts) {
                    _status.value = {
                      "feel": _status.value["feel"],
                      "kudos": _status.value["kudos"],
                      "disappointed": _status.value["disappointed"],
                      "fakes": fakes,
                      "trusts": trusts,
                    };
                  },
                ),
              );
            },
          ),

          /*  */
          SizedBox(height: 0.015.sh),
          IconButton(
            onPressed: _handleDownload,
            icon: const Icon(FontAwesomeIcons.download, size: 34),
          ),
          SizedBox(height: 0.025.sh),
        ],
      ),
    );
  }
}
