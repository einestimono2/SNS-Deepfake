import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/features/upload/upload.dart';
import 'package:sns_deepfake/features/video/presentation/widgets/video_widget.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/blocs.dart';

const selectedStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 20,
);

final unselectedStyle = TextStyle(
  color: Colors.white.withOpacity(0.5),
  fontSize: 19,
  fontWeight: FontWeight.normal,
);

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final ValueNotifier<int> _idx = ValueNotifier(0);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getListVideo() async {
    context
        .read<ListVideoBloc>()
        .add(const GetListVideo(size: AppStrings.listVideoPageSize));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ListVideoBloc, ListVideoState>(
          builder: (context, state) {
            if (state.isInitState) {
              return Container(
                width: double.infinity,
                height: 0.85.sh,
                alignment: Alignment.center,
                child: const AppIndicator(),
              );
            }

            return PageView.builder(
              itemCount: state.videos.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) =>
                  context.read<ListVideoBloc>().add(VideoIndexChanged(index)),
              itemBuilder: (context, index) {
                _loading.value = !state.hasReachedMax &&
                    state.isLoading &&
                    index == state.videos.length - 1;

                return VideoWidget(
                  isFirstVideo: index == 0,
                  controller: state.controllers[index]!,
                  video: state.videos[index],
                );
              },
            );
          },
        ),

        /*  */
        _header(),

        /* Loading */
        Align(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, value, child) {
              return AnimatedCrossFade(
                alignment: Alignment.bottomCenter,
                sizeCurve: Curves.decelerate,
                duration: const Duration(milliseconds: 400),
                firstChild: Padding(
                  padding: EdgeInsets.only(bottom: 0.025.sh),
                  child: const AppIndicator(size: 28),
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            },
          ),
        ),

        /*  */
        Align(
          alignment: Alignment.center,
          child: BlocBuilder<DownloadBloc, DownloadState>(
            builder: (context, state) {
              if (state is DownloadInProgressState) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: context.minBackgroundColor(),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: AppIndicator(size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${state.percent}%",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }

  ValueListenableBuilder<int> _header() {
    return ValueListenableBuilder(
        valueListenable: _idx,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(top: 0.035.sh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _idx.value = 0,
                  child: Text(
                    "VIDEO_TEXT".tr(),
                    style: value == 0 ? selectedStyle : unselectedStyle,
                  ),
                ),
                const SizedBox(width: 6),
                Text("|", style: unselectedStyle),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _idx.value = 1,
                  child: Text(
                    "Deepfake",
                    style: value == 1 ? selectedStyle : unselectedStyle,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
