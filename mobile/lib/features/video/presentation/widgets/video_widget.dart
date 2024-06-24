// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/libs/libs.dart';
import 'package:sns_deepfake/features/upload/presentation/presentation.dart';
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

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;

    super.initState();

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
    final fileName = widget.video.videos[0].url.split('/').last;

    context.read<DownloadBloc>().add(
          DownloadVideoSubmit(fileName: fileName, context: context),
        );

    // bool _permission = await PermissionHelper.request([Permission.storage]);

    // print(_permission);

    // if (_permission) {
    // } else {
    //   context.showError(message: "Không đủ quyền hạn");
    // }
  }

  void _handleNavProfile() {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: widget.controller.value.hasError
              ? Center(
                  child: SizedBox(
                    height: 0.35.sh,
                    width: double.infinity,
                    child: const LocalImage(path: AppImages.brokenImage),
                  ),
                )
              : VideoPlayer(widget.controller),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 12, bottom: 8),
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
                widget.video.author.username ?? "",
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
    return Column(
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
              const Icon(FontAwesomeIcons.solidHeart, size: 36),
              Text(
                "1K",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
          onTap: () {},
        ),
        SizedBox(height: 0.015.sh),
        InkWell(
          child: Column(
            children: [
              const Icon(FontAwesomeIcons.solidComment, size: 36),
              Text(
                "1K",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
          onTap: () {},
        ),
        SizedBox(height: 0.015.sh),
        IconButton(
          onPressed: _handleDownload,
          icon: const Icon(FontAwesomeIcons.download, size: 34),
        ),
        SizedBox(height: 0.025.sh),
      ],
    );
  }
}
