import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../../group/group.dart';
import '../../data/data.dart';
import '../blocs/blocs.dart';

class EditPostPage extends StatefulWidget {
  final int id;

  const EditPostPage({super.key, required this.id});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final FocusNode _fn = FocusNode();

  late final ValueNotifier<int> _selectedGroup;
  late PostModel post;
  late final TextEditingController _controller;
  late final List<String> _images;
  final List<String> _delImages = [];
  final List<String> _newImages = [];
  late final List<String> _videos;
  final List<String> _delVideos = [];
  final List<String> _newVideos = [];

  @override
  void initState() {
    post = (context.read<ListPostBloc>().state as ListPostSuccessfulState)
        .posts
        .firstWhere((e) => e.id == widget.id);

    _selectedGroup = ValueNotifier(post.group?.id ?? 0);
    _controller = TextEditingController(text: post.description);
    _images = post.images.map((e) => e.url).toList();
    _videos = post.videos.map((e) => e.url).toList();

    super.initState();
  }

  void _handleSave() {}

  void _handleChangeGroup(List<GroupModel> groups, int myId) async {
    await showDialog(
      context: context,
      builder: (context) => SelectGroupCard(
        groups: groups,
        myId: myId,
        currentSelected: _selectedGroup.value,
        titleText: "POST_AUDIENCE_TEXT".tr(),
        btnText: "CONFIRM_TEXT".tr(),
      ),
    ).then((id) => id != null ? _selectedGroup.value = id : null);
  }

  @override
  void dispose() {
    _fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SliverPage(
        title: "EDIT_POST_TITLE_TEXT".tr(),
        centerTitle: true,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: _handleSave,
            child: ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, value, child) => value
                  ? const AppIndicator(size: 22)
                  : Text(
                      "SAVE_TEXT".tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            ),
          ),
          const SizedBox(width: 6),
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
                          InkWell(
                            onTap: () => _handleChangeGroup(
                              state.groups,
                              state.user!.id!,
                            ),
                            borderRadius: BorderRadius.circular(3),
                            child: ValueListenableBuilder(
                              valueListenable: _selectedGroup,
                              builder: (context, value, child) {
                                int _cur = state.groups
                                    .indexWhere((e) => e.id == value);

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: AppColors.kPrimaryColor
                                        .withOpacity(0.25),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 6),
                                      Icon(
                                        value != 0
                                            ? FontAwesomeIcons.lock
                                            : FontAwesomeIcons.earthAsia,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _cur == -1
                                            ? "PUBLIC_TEXT".tr()
                                            : state.groups[_cur].groupName ??
                                                "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        FontAwesomeIcons.caretDown,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 3),
                                    ],
                                  ),
                                );
                              },
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
                controller: _controller,
                maxLines: null,
                minLines: _images.isEmpty &&
                        _newImages.isEmpty &&
                        _videos.isEmpty &&
                        _newVideos.isEmpty
                    ? 20
                    : null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'WHATS_ON_YOUR_MIND_TEXT'.tr(),
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

          /* Images */
          if (_images.isNotEmpty || _newImages.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildImages(),
            ),

          /* Videos */
          if (_videos.isNotEmpty || _newVideos.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildVideos(),
            )
        ],
      ),
    );
  }

  Widget _buildImages() {
    return Wrap(
      runSpacing: 6,
      spacing: 6,
      children: [
        ..._images.map((e) => _buildImage(e, true)),
        ..._newImages.map((e) => _buildImage(e, false)),
      ],
    );
  }

  Widget _buildVideos() {
    return Wrap(
      runSpacing: 6,
      spacing: 6,
      children: [
        ..._images.map((e) => _buildVideo(e, true)),
        ..._newImages.map((e) => _buildVideo(e, false)),
      ],
    );
  }

  Widget _buildImage(String url, bool fromNetwork) {
    return Stack(
      children: [
        fromNetwork ? AnimatedImage(url: url.fullPath) : LocalImage(path: url),
        Positioned(
          right: 0,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => setState(() {
              if (!mounted) return;

              if (fromNetwork) {
                _images.remove(url);
                _delImages.add(url);
              } else {
                _newImages.remove(url);
              }
            }),
            icon: const Icon(Icons.clear),
          ),
        )
      ],
    );
  }

  Widget _buildVideo(String url, bool fromNetwork) {
    return Stack(
      children: [
        fromNetwork
            ? AppVideo(url.fullPath, isNetwork: true)
            : AppVideo(url, isNetwork: false),
        Positioned(
          right: 0,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => setState(() {
              if (!mounted) return;

              if (fromNetwork) {
                _videos.remove(url);
                _delVideos.add(url);
              } else {
                _newVideos.remove(url);
              }
            }),
            icon: const Icon(Icons.clear),
          ),
        )
      ],
    );
  }
}
