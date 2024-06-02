import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/group/group.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../../news_feed/presentation/widgets/grid_image_video.dart';

class CreateGroupPostPage extends StatefulWidget {
  final int groupId;

  const CreateGroupPostPage({
    super.key,
    required this.groupId,
  });

  @override
  State<CreateGroupPostPage> createState() => _CreateGroupPostPageState();
}

class _CreateGroupPostPageState extends State<CreateGroupPostPage>
    with TickerProviderStateMixin {
  bool _postable = false;
  Timer? _debounce;

  final FocusNode _fn = FocusNode();

  final List<String> _files = [];
  final TextEditingController _controller = TextEditingController();

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  late GroupModel group;

  @override
  void initState() {
    group = context
        .read<AppBloc>()
        .state
        .groups
        .firstWhere((e) => e.id == widget.groupId);
    super.initState();
  }

  void _handleExit() {
    if (!_postable) {
      context.pop();
      return;
    }

    showAppAlertDialog(
      barrierDismissible: false,
      context: context,
      title: "CANCEL_POST_DIALOG_TITLE_TEXT".tr(),
      content: "CANCEL_POST_DIALOG_CONTENT_TEXT".tr(),
      okText: "CONTINUE_TEXT".tr(),
      cancelText: "CANCEL_POST_DIALOG_TITLE_TEXT".tr(),
      onCancel: () => context
        ..pop()
        ..pop(),
    );
  }

  void _handlePost() {
    if (_loading.value) return;

    _loading.value = true;
    context.read<GroupPostBloc>().add(CreateGroupPostSubmit(
          group: group,
          files: _files,
          description: _controller.text,
          status: "status",
          onSuccess: () => Navigator.pop(context),
          onError: (msg) {
            _loading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  void _handlePick(int type) async {
    /* Image or video */
    if (type == 0) {
      final files = await FileHelper.pickMultiMedia();
      if (files != null && files.isNotEmpty) {
        for (var e in files) {
          _files.add(e.path);
        }

        _postable = true;
        setState(() {});
      }
    }
    /* Camera */
    else if (type == 1) {
      //
    }
  }

  void _handleDelete(int index) {
    File(_files[index]).delete();

    setState(() {
      if (mounted) {
        _files.removeAt(index);

        _postable = _controller.text.isNotEmpty;
      }
    });
  }

  /* Sau khi không còn nhập nữa thì chạy function sau 500 miliseconds */
  void _handleInput(value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (mounted) {
          _postable = value.isNotEmpty;
        }
      });
    });
  }

  @override
  void dispose() {
    _fn.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* Do gắn rootNavigationKey để ẩn bottomNavBar dùng chung */
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      body: SliverPage(
        title: "CREATE_POST_TITLE_TEXT".tr(),
        centerTitle: true,
        leading: IconButton(
          onPressed: _handleExit,
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: _postable ? _handlePost : null,
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, value, child) => value
                  ? const AppIndicator(size: 22)
                  : Text(
                      "POST_TEXT".tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            ),
          ),
          SizedBox(width: 6.w),
        ],
        slivers: [
          /* Info */
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      /* Avatar */
                      AnimatedImage(
                        width: 0.125.sw,
                        height: 0.125.sw,
                        url: state.user?.avatar?.fullPath ?? "",
                        isAvatar: true,
                      ),

                      /* Info + Actions */
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            state.user?.username ?? state.user?.email ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h),

                          /*  */
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.blueAccent.shade200,
                              border: const Border(),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 6),
                                const Icon(
                                  FontAwesomeIcons.usersRectangle,
                                  size: 12,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${"MEMBERS_OF_TEXT".tr()} ${group.groupName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(width: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          /* Text */
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {},
              child: TextField(
                focusNode: _fn,
                onTapOutside: (_) => _fn.unfocus(),
                onChanged: _handleInput,
                controller: _controller,
                maxLines: null,
                minLines: _files.isEmpty ? 20 : null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'CREATE_GROUP_POST_HINT_TEXT'.tr(),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                ),
                cursorWidth: 1.5,
              ),
            ),
          ),

          /* Grid Image */
          SliverToBoxAdapter(
            child: GridImageVideo(
              files: _files,
              onDelete: _handleDelete,
            ),
          ),

          /* Space */
          SliverToBoxAdapter(
            child: SizedBox(
              height: 72.h,
            ),
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        enableDrag: true,
        showDragHandle: false,
        onClosing: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
        ),
        onDragStart: (_) => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
          ),
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _pickFile(
                onTap: () => _handlePick(0),
                icon: Icons.image,
                color: Colors.green,
                label: "IMAGE_VIDEO_TEXT".tr(),
              ),
              _pickFile(
                onTap: () => _handlePick(1),
                icon: Icons.camera,
                color: Colors.blue,
                label: "CAMERA_TEXT".tr(),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        animationController: BottomSheet.createAnimationController(this),
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: 0.25.sw,
                height: 5.h,
                margin: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.minBackgroundColor(),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Wrap(
                spacing: 6.w,
                children: [
                  _pickFile(
                    onTap: () => _handlePick(0),
                    icon: Icons.image,
                    color: Colors.green,
                  ),
                  _pickFile(
                    onTap: () => _handlePick(1),
                    icon: Icons.camera,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _pickFile({
    required VoidCallback onTap,
    required IconData icon,
    Color? color,
    String? label,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(6.r),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
        child: label == null
            ? Icon(icon, size: 30.sp, color: color ?? Colors.green)
            : Row(
                children: [
                  SizedBox(width: 6.w),
                  Icon(icon, size: 30.sp, color: color ?? Colors.green),
                  SizedBox(width: 12.w),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
