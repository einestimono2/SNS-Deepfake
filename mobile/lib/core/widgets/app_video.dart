import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class AppVideo extends StatefulWidget {
  final String url;
  final bool isNetwork;
  final bool onlyShowThumbnail;
  final Map<String, String> headers;

  const AppVideo(
    this.url, {
    super.key,
    this.isNetwork = false,
    this.onlyShowThumbnail = false,
    this.headers = const {
      'range': 'bytes=0-',
    },
  });

  @override
  State<AppVideo> createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;

  VideoPlayerController getType() {
    if (widget.isNetwork) {
      return VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: widget.headers,
      );
    } else {
      return VideoPlayerController.file(File(widget.url));
    }
  }

  @override
  void initState() {
    _controller = getType()
      ..initialize().then((_) {
        if (widget.onlyShowThumbnail) {
          setState(() {});
          return;
        }

        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
          aspectRatio: _controller.value.aspectRatio,
        );

        setState(() {}); // when your thumbnail will show.
      }).onError((error, stackTrace) {
        AppLogger.error(error.toString(), error);
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.hasError) {
      return const LocalImage(path: AppImages.errorImage);
    }

    return _controller.value.isInitialized
        ? widget.onlyShowThumbnail
            ? VideoPlayer(_controller)
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(controller: chewieController),
              )
        : const Center(child: CircularProgressIndicator());
  }
}
