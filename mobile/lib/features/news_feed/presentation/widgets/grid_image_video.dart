import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import 'modal_list_image.dart';

class GridImageVideo extends StatelessWidget {
  final List<String> files;
  final Function(int)? onDelete;

  const GridImageVideo({
    super.key,
    required this.files,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    if (files.length <= 1) {
      return SizedBox(
        width: 1.sw,
        height: 0.5.sh,
        child: Stack(
          children: [
            fileIsVideo(files[0])
                ? AppVideo(files[0])
                : Image.file(
                    File(files[0]),
                    width: 1.sw,
                    fit: BoxFit.cover,
                  ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => onDelete?.call(0),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                icon: const Icon(Icons.delete),
              ),
            )
          ],
        ),
      );
    } else {
      return _buildDynamicType(context, files.length);
    }
  }

  Widget _buildDynamicType(BuildContext context, int len) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _image(context, len > 2 ? 0.3.sh : 0.5.sh, 0),
            if (len == 2 || len >= 5) ...[
              const SizedBox(width: 4),
              _image(context, len > 2 ? 0.3.sh : 0.5.sh, len == 2 ? 1 : 4),
            ]
          ],
        ),
        if (len > 2) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              _image(context, 0.25.sh, 1),
              const SizedBox(width: 4),
              _image(context, 0.25.sh, 2),
              if (len >= 4) ...[
                const SizedBox(width: 4),
                _image(context, 0.25.sh, 3)
              ],
            ],
          ),
        ]
      ],
    );
  }

  Widget _image(BuildContext context, double height, int imageIdx) {
    return Expanded(
      child: InkWell(
        onTap: () => _openBottomSheet(context, imageIdx),
        child: fileIsVideo(files[imageIdx])
            ? Container(
                height: height,
                alignment: Alignment.center,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AppVideo(files[imageIdx], onlyShowThumbnail: true),
                    const Positioned(
                      bottom: 0,
                      left: 2,
                      child: Icon(Icons.videocam),
                    ),
                    if (imageIdx == 3 && files.length > 5)
                      Text(
                        '+${files.length - 4}',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ],
                ),
              )
            : Container(
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: FileImage(File(files[imageIdx])),
                  ),
                ),
                alignment: Alignment.center,
                child: (imageIdx == 3 && files.length > 5)
                    ? Text(
                        '+${files.length - 4}',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context, int idx) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true, // full screen
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => ModalListUpload(
        initScrollIdx: idx,
        files: files,
        onDelete: onDelete,
      ),
    );
  }
}

class PostGridImage extends StatelessWidget {
  final List<String> files;
  final double separateSize;

  const PostGridImage({
    super.key,
    required this.files,
    this.separateSize = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    if (files.length <= 1) {
      return AnimatedImage(
        width: 1.sw,
        // height: 0.35.sh,
        url: files.first,
        fit: BoxFit.cover,
        errorImage: AppImages.brokenImage,
      );
    } else {
      return _buildDynamicType(context, files.length);
    }
  }

  Widget _buildDynamicType(BuildContext context, int len) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _image(context, len > 2 ? 0.3.sh : 0.5.sh, 0),
            if (len == 2 || len >= 5) ...[
              SizedBox(width: separateSize),
              _image(context, len > 2 ? 0.3.sh : 0.5.sh, len == 2 ? 1 : 4),
            ]
          ],
        ),
        if (len > 2) ...[
          SizedBox(height: separateSize),
          Row(
            children: [
              _image(context, 0.25.sh, 1),
              SizedBox(width: separateSize),
              _image(context, 0.25.sh, 2),
              if (len >= 4) ...[
                SizedBox(width: separateSize),
                _image(context, 0.25.sh, 3)
              ],
            ],
          ),
        ]
      ],
    );
  }

  Widget _image(BuildContext context, double height, int imageIdx) {
    Widget _img = AnimatedImage(
      height: height,
      url: files[imageIdx],
      errorImage: AppImages.brokenImage,
    );

    return Expanded(
      child: (imageIdx == 3 && files.length > 5)
          ? Stack(
              children: [
                _img,
                Text(
                  '+${files.length - 4}',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          : _img,
    );
  }

  // void _openBottomSheet(BuildContext context, int idx) {
  //   showModalBottomSheet(
  //     context: context,
  //     enableDrag: false,
  //     isScrollControlled: true, // full screen
  //     useSafeArea: true,
  //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //     builder: (context) => ModalPostListMedia(
  //       files: files,
  //       isVideo: false,
  //     ),
  //   );
  // }
}

class PostGridVideo extends StatelessWidget {
  final List<String> files;
  final double separateSize;

  const PostGridVideo({
    super.key,
    required this.files,
    this.separateSize = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    if (files.length <= 1) {
      return AppVideo(
        files.first,
        isNetwork: true,
      );
    } else {
      return _buildDynamicType(context, files.length);
    }
  }

  Widget _buildDynamicType(BuildContext context, int len) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _image(context, len > 2 ? 0.3.sh : 0.5.sh, 0),
            if (len == 2 || len >= 5) ...[
              SizedBox(width: separateSize),
              _image(context, len > 2 ? 0.3.sh : 0.5.sh, len == 2 ? 1 : 4),
            ]
          ],
        ),
        if (len > 2) ...[
          SizedBox(height: separateSize),
          Row(
            children: [
              _image(context, 0.25.sh, 1),
              SizedBox(width: separateSize),
              _image(context, 0.25.sh, 2),
              if (len >= 4) ...[
                SizedBox(width: separateSize),
                _image(context, 0.25.sh, 3)
              ],
            ],
          ),
        ]
      ],
    );
  }

  Widget _image(BuildContext context, double height, int imageIdx) {
    return Expanded(
      child: InkWell(
        onTap: () => _openBottomSheet(context, imageIdx),
        child: (imageIdx == 3 && files.length > 5)
            ? Stack(
                children: [
                  AnimatedImage(
                    height: height,
                    url: files[imageIdx],
                  ),
                  Text(
                    '+${files.length - 4}',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            : AnimatedImage(
                height: height,
                url: files[imageIdx],
              ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context, int idx) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true, // full screen
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => ModalPostListMedia(
        files: files,
        isVideo: false,
      ),
    );
  }
}
