import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/profile/presentation/widgets/audio_card.dart';
import 'package:sns_deepfake/features/profile/presentation/widgets/record_widget.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

class CreateVideoDeepfakePage extends StatefulWidget {
  const CreateVideoDeepfakePage({super.key});

  @override
  State<CreateVideoDeepfakePage> createState() =>
      _CreateVideoDeepfakePageState();
}

class _CreateVideoDeepfakePageState extends State<CreateVideoDeepfakePage> {
  final ScrollController _controller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtl = TextEditingController();
  final FocusNode _titleFN = FocusNode();

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _creatable = ValueNotifier(false);

  final ValueNotifier<String?> _video = ValueNotifier(null);
  final ValueNotifier<String?> _image = ValueNotifier(null);
  final ValueNotifier<List<String>> _audios = ValueNotifier([]);

  @override
  void dispose() {
    _titleFN.unfocus();
    super.dispose();
  }

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

  void _handleUploadAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    final paths = result?.paths.where((e) => e != null).map((e) => e!).toList();

    if (paths?.isNotEmpty ?? false) {
      _audios.value = [..._audios.value, ...paths!];

      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Durations.long1,
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _handleRecordAudio() {
    openModalBottomSheet(
      context: context,
      enableDrag: false,
      child: RecordWidget(
        onRecorded: (url) {
          if (url.isEmpty) return;

          _audios.value = [..._audios.value, ...url];

          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Durations.long1,
            curve: Curves.fastOutSlowIn,
          );
        },
      ),
    );
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate() && _titleCtl.text.isNotEmpty) {
      _loading.value = true;

      context.read<DeepfakeBloc>().add(CreateVideoDeepfakeSubmit(
            title: _titleCtl.text,
            video: _video.value!,
            image: _image.value!,
            audios: _audios.value.isEmpty ? null : _audios.value,
            onSuccess: () {
              _loading.value = false;
              context.pop();
            },
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverPage(
        controller: _controller,
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
                  title: "DEEPFAKE_TITLE_TEXT".tr(),
                  margin: const EdgeInsets.only(bottom: 8, top: 18),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _titleCtl,
                    focusNode: _titleFN,
                    onTapOutside: (_) => _titleFN.unfocus(),
                    onFieldSubmitted: (_) => _titleFN.unfocus(),
                    validator: AppValidations.validateContent,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      hintText: "DEEPFAKE_TITLE_HINT_TEXT".tr(),
                    ),
                  ),
                ),

                /*  */
                SectionTitle(
                  showTopSeparate: true,
                  title: "ORIGIN_AUDIOS_TEXT".tr(),
                  margin: const EdgeInsets.only(top: 18),
                  actions: [
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(3),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _handleRecordAudio,
                      icon: const Icon(Icons.mic),
                    ),

                    /*  */
                    const SizedBox(width: 6),
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(3),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _handleUploadAudio,
                      icon: const Icon(Icons.upload),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: _audios,
                  builder: (context, value, child) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return AudioCard(
                          url: value[index],
                          isFile: true,
                          onDelete: (url) {
                            _audios.value =
                                _audios.value.where((e) => e != url).toList();
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
