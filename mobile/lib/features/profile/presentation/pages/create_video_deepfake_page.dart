import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/adaptive/app_indicator.dart';
import 'package:sns_deepfake/core/widgets/app_image.dart';
import 'package:sns_deepfake/core/widgets/app_video.dart';
import 'package:sns_deepfake/core/widgets/section_title.dart';
import 'package:sns_deepfake/core/widgets/sliver_page.dart';

import '../../../../core/utils/utils.dart';

class CreateVideoDeepfakePage extends StatefulWidget {
  const CreateVideoDeepfakePage({super.key});

  @override
  State<CreateVideoDeepfakePage> createState() =>
      _CreateVideoDeepfakePageState();
}

class _CreateVideoDeepfakePageState extends State<CreateVideoDeepfakePage> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _creatable = ValueNotifier(false);

  final ValueNotifier<String?> _video = ValueNotifier(null);
  final ValueNotifier<String?> _image = ValueNotifier(null);

  void _handleUploadVideo() async {
    final video = await FileHelper.pickVideo();

    if (video != null) {
      _video.value = video.path;
      _creatable.value = _image.value != null;
    }
  }

  void _handleUploadImage() async {
    final image = await FileHelper.pickImage();

    if (image != null) {
      _image.value = image;
      _creatable.value = _video.value != null;
    }
  }

  void _handleCreate() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "CREATE_VIDEO_DEEPFAKE_TEXT".tr(),
      centerTitle: true,
      actions: [
        ValueListenableBuilder(
          valueListenable: _creatable,
          builder: (context, canCreate, child) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: canCreate ? _handleCreate : null,
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, value, child) => value
                  ? const AppIndicator(size: 22)
                  : Text(
                      "CREATE_TEXT".tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 3, 16, 16),
          sliver: SliverList.list(
            children: [
              SectionTitle(
                title: "ORIGIN_VIDEO_TEXT".tr(),
                margin: const EdgeInsets.only(bottom: 8),
                onShowMore: () {
                  _video.value = null;
                  _creatable.value = false;
                },
                showMoreText: "DELETE_TEXT".tr(),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 0.35.sh,
                ),
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: _video,
                  builder: (context, video, child) => video != null
                      ? AppVideo(video)
                      : InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _handleUploadVideo,
                          child: Container(
                            width: double.infinity,
                            height: 0.35.sh,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: context.minBackgroundColor(),
                              ),
                              color: context.minBackgroundColor(),
                              boxShadow: highModeShadow,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.upload, size: 64),
                          ),
                        ),
                ),
              ),

              /*  */
              SectionTitle(
                showTopSeparate: true,
                title: "ORIGIN_IMAGE_TEXT".tr(),
                margin: const EdgeInsets.only(bottom: 8, top: 18),
                onShowMore: () {
                  _image.value = null;
                  _creatable.value = false;
                },
                showMoreText: "DELETE_TEXT".tr(),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 0.35.sh,
                ),
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: _image,
                  builder: (context, image, child) => image != null
                      ? LocalImage(
                          path: image,
                          fromFile: true,
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _handleUploadImage,
                          child: Container(
                            width: double.infinity,
                            height: 0.35.sh,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: context.minBackgroundColor(),
                              ),
                              color: context.minBackgroundColor(),
                              boxShadow: highModeShadow,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.upload, size: 64),
                          ),
                        ),
                ),
              ),

              /*  */
              SectionTitle(
                showTopSeparate: true,
                title: "ORIGIN_AUDIOS_TEXT".tr(),
                margin: const EdgeInsets.only(bottom: 8, top: 18),
                onShowMore: () async {
                  String? selectedDirectory =
                      await FilePicker.platform.getDirectoryPath();

                  print("======> $selectedDirectory");
                },
                showMoreText: "DELETE_ALL_TEXT".tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
