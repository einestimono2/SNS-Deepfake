import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/group/group.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../news_feed/presentation/widgets/color_separate.dart';
import '../../../news_feed/presentation/widgets/post_card.dart';
import '../../../news_feed/presentation/widgets/shimmer_post.dart';

class GroupDetailsPage extends StatefulWidget {
  final int id;
  final Map<String, dynamic>? baseInfo;

  const GroupDetailsPage({
    super.key,
    required this.id,
    this.baseInfo,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  String? coverPhoto;
  String? title;
  late int myId;

  final double py = 12.w;

  late final _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;
    _getGroupDetailsAndPosts();

    coverPhoto = widget.baseInfo?['coverPhoto'];
    title = widget.baseInfo?['groupName'];

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleOutOrManage(bool owner) {
    if (owner) {
      context.goNamed(
        Routes.manageGroup.name,
        pathParameters: {"id": widget.id.toString()},
        extra: {"isMyGroup": true},
      );
    } else {
      if (_loading.value) return;

      _loading.value = true;
      context.read<GroupActionBloc>().add(LeaveGroupSubmit(
            groupId: widget.id,
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () => Navigator.of(context).pop(),
          ));
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore) {
      _loadingMore = true;

      context.read<GroupPostBloc>().add(LoadMoreListPost(
            groupId: widget.id,
            page: ++_page,
            size: AppStrings.listPostPageSize,
          ));
    }
  }

  Future<void> _getGroupDetailsAndPosts() async {
    _loadingMore = true;
    _page = 1;

    // Gọi getListPost khi hoàn thành getGroupDetails rồi
    context.read<GroupActionBloc>().add(GetGroupDetails(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupActionBloc, GroupActionState>(
      builder: (context, state) {
        return RefreshIndicator.adaptive(
          onRefresh: _getGroupDetailsAndPosts,
          edgeOffset: kToolbarHeight,
          displacement: 0,
          backgroundColor: context.minBackgroundColor(),
          child: CustomScrollView(
            slivers: [
              _buildAppbar(state),
              SliverFillRemaining(child: _body(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _body(GroupActionState state) {
    if (state is GroupActionInProgressState ||
        state is GroupActionInitialState) {
      return const Center(
        child: AppIndicator(),
      );
    } else if (state is GroupActionSuccessfulState) {
      bool owner = state.group!.creatorId == myId;

      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPhoto(state.group!, owner),
            _buildInfo(state.group!),
            const SizedBox(height: 6),
            _buildButton(owner),
            const SizedBox(height: 12),
            _buildPostTitle(),
            _buildPosts(state.group!),
            const SizedBox(height: 6),
          ],
        ),
      );
    } else {
      return Center(
        child: ErrorCard(
          message: (state as GroupActionFailureState).message,
          onRefresh: () =>
              context.read<GroupActionBloc>().add(GetGroupDetails(widget.id)),
        ),
      );
    }
  }

  Widget _buildPostTitle() {
    return Column(
      children: [
        const ColorSeparate(
            isSliverType: false, paddingVertical: 0, thickness: 2),
        SectionTitle(
          title: "Bài viết",
          margin: EdgeInsets.symmetric(horizontal: py),
        ),
        const ColorSeparate(isSliverType: false, thickness: 2),
      ],
    );
  }

  Widget _buildPosts(GroupModel group) {
    return BlocBuilder<GroupPostBloc, GroupPostState>(
      builder: (context, state) {
        if (state is GroupPostInProgressState ||
            state is GroupPostInitialState) {
          return const ShimmerPost(length: 5);
        } else if (state is GroupPostSuccessfulState) {
          _loadingMore = false;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const ColorSeparate(
                  isSliverType: false,
                  thickness: 2,
                ),
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (_, idx) => idx < state.posts.length
                    ? PostCard(
                        post: state.posts[idx],
                        showGroup: false,
                        adminId: group.creatorId,
                        myId: myId,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: AppIndicator(size: 32)),
                      ),
              ),

              /*  */
              if (state.hasReachedMax) _defaultPostCard(group),
            ],
          );
        } else {
          return Center(
            child: ErrorCard(
              message: (state as GroupPostFailureState).message,
              onRefresh: () => context.read<GroupPostBloc>().add(GetListPost(
                    groupId: widget.id,
                    page: 1,
                    size: AppStrings.listPostPageSize,
                  )),
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(bool owner) {
    return Row(
      children: [
        SizedBox(width: py),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 6),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              backgroundColor: owner ? null : Colors.redAccent.shade200,
            ),
            onPressed: () => _handleOutOrManage(owner),
            icon: Icon(
              owner ? Icons.privacy_tip : Icons.login_sharp,
            ),
            label: Text(
              owner ? "MANAGE_TEXT".tr() : "LEAVE_GROUP_TEXT".tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 6),
              backgroundColor: Colors.blueAccent,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: () => context.goNamed(
              Routes.inviteMember.name,
              pathParameters: {"id": widget.id.toString()},
            ),
            icon: const Icon(Icons.group_add),
            label: Text(
              "INVITE_TEXT".tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: py),
      ],
    );
  }

  Widget _buildInfo(GroupModel gr) {
    int numAvatar = ((1.sw - py * 2) / (36 * 0.75)).floor();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: py, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.goNamed(
              Routes.manageGroup.name,
              pathParameters: {"id": widget.id.toString()},
              extra: {"isMyGroup": gr.creatorId == myId},
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gr.groupName!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios_rounded, size: 16.sp),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "GROUP_MEMBERS_TEXT".plural(gr.members.length),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 36 * 0.25 / 2),
              ...gr.members.take(numAvatar - 1).map((e) => Align(
                    widthFactor: 0.75,
                    child: AnimatedImage(
                      url: e.avatar?.fullPath ?? "",
                      isAvatar: true,
                      width: 36,
                      height: 36,
                    ),
                  )),
              if (gr.members.length >= numAvatar)
                const Align(
                  widthFactor: 0.75,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child:
                          Icon(FontAwesomeIcons.ellipsis, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto(GroupModel gr, bool owner) {
    return SizedBox(
      height: 0.25.sh,
      width: double.infinity,
      child: Stack(
        children: [
          AnimatedImage(
            url: gr.coverPhoto?.fullPath ??
                AppImages.defaultGroupCoverPhotoNetwork,
            height: double.infinity,
            width: double.infinity,
            errorImage: AppImages.brokenImage,
          ),
          if (owner)
            Positioned(
              bottom: 3,
              right: 6,
              child: UploadButton(
                size: 16.sp,
                label: "EDIT_TEXT".tr(),
                icon: Icons.edit,
                id: "UPLOAD_GROUP_COVER_PHOTO",
                onCompleted: (String? url, String? id) {
                  if (url != null && id == "UPLOAD_GROUP_COVER_PHOTO") {
                    context.read<GroupActionBloc>().add(
                          UpdateGroupSubmit(
                            id: gr.id,
                            coverPhoto: url,
                            onSuccess: () {},
                            onError: (msg) => context.showError(message: msg),
                          ),
                        );
                  }
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _buildAppbar(GroupActionState state) {
    bool success = state is GroupActionSuccessfulState;

    String photo =
        (success ? state.group!.coverPhoto?.fullPath : coverPhoto?.fullPath) ??
            AppImages.defaultGroupCoverPhotoNetwork;

    String groupName = (success ? state.group!.groupName : title) ?? "";

    return SliverAppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 0,
      titleSpacing: 0,
      pinned: true,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 2),
          const BackButton(),
          const SizedBox(width: 3),
          AnimatedImage(
            url: photo,
            radius: 6,
            width: kToolbarHeight / 1.75,
            height: kToolbarHeight / 1.75,
            errorImage: AppImages.brokenImage,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              groupName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (success)
            IconButton(
              style: customButtonStyle(6),
              onPressed: () => context.goNamed(
                Routes.createGroupPost.name,
                pathParameters: {"id": widget.id.toString()},
              ),
              icon: const Icon(FontAwesomeIcons.penToSquare, size: 20),
            ),
          if (success)
            IconButton(
              onPressed: () => context.goNamed(
                Routes.manageGroup.name,
                pathParameters: {"id": widget.id.toString()},
                extra: {"isMyGroup": state.group!.creatorId == myId},
              ),
              style: customButtonStyle(6),
              icon: const Icon(Icons.info_outline),
            ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _defaultPostCard(GroupModel group) {
    int idx = group.members.indexWhere((e) => e.id == myId);
    if (idx == -1) return const SizedBox.shrink();

    final admin = group.members[idx];

    return Column(
      children: [
        const ColorSeparate(
          isSliverType: false,
          thickness: 2,
        ),
        Row(
          children: [
            SizedBox(width: py),

            /* Avatar */
            GestureDetector(
              onTap: () => admin.id == myId
                  ? context.pushNamed(Routes.myProfile.name)
                  : context.pushNamed(
                      Routes.otherProfile.name,
                      pathParameters: {"id": admin.id.toString()},
                    ),
              child: AnimatedImage(
                width: 0.1.sw,
                height: 0.1.sw,
                url: admin.avatar?.fullPath ?? "",
                isAvatar: true,
              ),
            ),

            /* Info */
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*  */
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: admin.username ?? admin.email,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => admin.id == myId
                                  ? context.pushNamed(Routes.myProfile.name)
                                  : context.pushNamed(
                                      Routes.otherProfile.name,
                                      pathParameters: {
                                        "id": admin.id.toString()
                                      },
                                    ),
                          ),
                          TextSpan(
                            text: " ${"CREATED_THE_GROUP_TEXT".tr()} ",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      height: 1,
                                    ),
                          ),
                          TextSpan(
                            text: group.groupName,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Durations.extralong1,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.blueAccent.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          margin: const EdgeInsets.only(right: 6),
                          child: Text(
                            "ADMIN_TEXT".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),

                        /*  */
                        Text(
                          DateHelper.getTimeAgo(
                            group.createdAt,
                            context.locale.languageCode,
                            showSuffixText: false,
                          ),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 12.sp,
                          child: Text(
                            "\u00b7",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(width: 1),
                        Icon(
                          FontAwesomeIcons.usersRectangle,
                          size: 10.sp,
                          color: Theme.of(context).textTheme.labelMedium!.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: py),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
