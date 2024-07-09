import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/color_separate.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../authentication/data/data.dart';
import '../../../friend/friend.dart';
import '../../../news_feed/presentation/widgets/post_card.dart';
import '../../../news_feed/presentation/widgets/shimmer_post.dart';
import '../blocs/blocs.dart';
import '../widgets/profile_friend_card.dart';
import '../widgets/shimmer_user_friends.dart';
import '../widgets/user_info_card.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ValueNotifier<String?> _avatar = ValueNotifier(null);
  final ValueNotifier<String?> _cover = ValueNotifier(null);

  final double py = 12.0;

  final ValueNotifier<bool> _avatarLoading = ValueNotifier(false);
  final ValueNotifier<bool> _coverLoading = ValueNotifier(false);

  late final _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  late final bool isChildRole;

  void _handleChangeAvatar(String? url) {
    if (url == null) return;

    // loading.value = true -- gọi khi chọn ảnh xong r
    context.read<ProfileActionBloc>().add(UpdateProfileSubmit(
          avatar: url,
          onSuccess: () {
            _avatarLoading.value = false;
            _avatar.value = url.fullPath;
          },
          onError: (msg) {
            _avatarLoading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  void _handleChangePhoto(String? url) {
    if (url == null) return;

    // loading.value = true -- gọi khi chọn ảnh xong r
    context.read<ProfileActionBloc>().add(UpdateProfileSubmit(
          coverPhoto: url,
          onSuccess: () {
            _coverLoading.value = false;
            _cover.value = url.fullPath;
          },
          onError: (msg) {
            _coverLoading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  @override
  void initState() {
    isChildRole = context.read<AppBloc>().state.user?.role == 0;

    // if (context.read<ListFriendBloc>().state is! LFSuccessfulState) {
    _getMyFriends();
    // }

    if (context.read<MyPostsBloc>().state is! MyPostsSuccessfulState) {
      _getMyPosts();
    }

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  void _getMyPosts() {
    context.read<MyPostsBloc>().add(const GetMyPosts(
          page: 1,
          size: AppStrings.listFriendPageSize,
        ));
  }

  void _getMyFriends() {
    context.read<ListFriendBloc>().add(const GetListFriend(
          page: 1,
          size: AppStrings.listFriendPageSize,
        ));
  }

  Future<void> handleRefresh() async {
    _getMyPosts();
    _getMyFriends();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<MyPostsBloc>().add(LoadMoreMyPosts(
            page: ++_page,
            size: AppStrings.listPostPageSize,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => SliverPage(
        title: state.user?.username ?? state.user?.email ?? "PROFILE_TEXT".tr(),
        titleStyle: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
        titleSpacing: 0,
        controller: _scrollController,
        onRefresh: handleRefresh,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                /* Cover Image */
                ..._coverImage(state.user?.coverImage?.fullPath ?? ""),

                /*  */
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0.25.sh - 54.r, 0, 0),
                  child: Column(
                    children: [
                      _avatarImage(state.user?.avatar?.fullPath ?? ""),
                      const SizedBox(height: 16),
                      Text(
                        state.user?.username ?? state.user?.email ?? "",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      /*  */
                      const SizedBox(height: 12),
                      const ColorSeparate(
                        isSliverType: false,
                        paddingVertical: 0,
                      ),
                      UserInfoCard(user: state.user!, paddingHorizontal: py),

                      /*  */
                      const SizedBox(height: 16),
                      const ColorSeparate(
                        isSliverType: false,
                        paddingVertical: 0,
                      ),
                      _userFriends(),

                      /*  */
                      const SizedBox(height: 16),
                      const ColorSeparate(
                        isSliverType: false,
                        paddingVertical: 0,
                      ),
                      _userPosts(state.user!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userFriends() {
    const int numCard = 4;
    const double separateSize = 8;
    final double cardWidth =
        (1.sw - py * 2 - separateSize * (numCard - 1)) / numCard;

    return Padding(
      padding: EdgeInsets.only(left: py, right: py),
      child: BlocBuilder<ListFriendBloc, ListFriendState>(
        builder: (context, state) {
          int numFriends = state is LFSuccessfulState ? state.totalCount : 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: "PROFILE_FRIENDS_TEXT".tr(),
                onShowMore: () => context.goNamed(
                    isChildRole ? Routes.childFriend.name : Routes.friend.name),
                showMoreText: "FIND_FRIEND_TEXT".tr(),
              ),
              if (numFriends != 0)
                Text(
                  "LIST_FRIEND_TEXT".plural(numFriends),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              const SizedBox(height: 16),

              /*  */
              if (state is LFFailureState)
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ErrorCard(
                    message: state.message,
                    onRefresh: _getMyFriends,
                  ),
                ),

              /*  */
              if (state is LFInProgressState || state is LFInitialState)
                ShimmerUserFriends(
                  cardWidth: cardWidth,
                  separateWidth: separateSize,
                ),

              /*  */
              if (state is LFSuccessfulState && numFriends == 0)
                Center(
                  child: NoDataCard(
                    description: "NO_FRIEND_DESCRIPTION_TEXT".tr(),
                    title: "NO_FRIEND_TEXT".tr(),
                  ),
                ),
              if (state is LFSuccessfulState && numFriends != 0)
                Wrap(
                  spacing: separateSize,
                  runSpacing: 6,
                  children: state.friends
                      .take(numCard * 2)
                      .map((e) => ProfileFriendCard(
                            friendModel: e,
                            width: cardWidth,
                            fromMyProfile: true,
                          ))
                      .toList(),
                ),
              if (state is LFSuccessfulState && numFriends > numCard * 2)
                SeeAllButton(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  onClick: () => context.pushNamed(isChildRole
                      ? Routes.childAllFriend.name
                      : Routes.allFriend.name),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _userPosts(UserModel user) {
    return Column(
      children: [
        SectionTitle(
          margin: EdgeInsets.only(left: py, right: py, bottom: 16),
          title: "YOUR_POSTS_TEXT".tr(),
        ),

        /*  */
        if (!isChildRole) ...[
          _createPostOption(user),
          const SizedBox(height: 6),
          const ColorSeparate(isSliverType: false, paddingVertical: 6),
        ],

        /*  */
        BlocBuilder<MyPostsBloc, MyPostsState>(
          builder: (context, state) {
            if (state is MyPostsInProgressState ||
                state is MyPostsInitialState) {
              return const ShimmerPost(length: 5);
            } else if (state is MyPostsSuccessfulState) {
              _loadingMore = false;
              _hasReachedMax = state.hasReachedMax;

              if (state.posts.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    const ColorSeparate(isSliverType: false),
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (_, idx) => idx < state.posts.length
                    ? PostCard(
                        post: state.posts[idx],
                        myId: user.id!,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: AppIndicator(size: 32)),
                      ),
              );
            } else {
              return ErrorCard(
                onRefresh: _getMyPosts,
                message: (state as MyPostsFailureState).message,
              );
            }
          },
        ),
      ],
    );
  }

  CircleAvatar _avatarImage(String userAvatar) {
    return CircleAvatar(
      backgroundColor: AppColors.kPrimaryColor,
      radius: 54.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: _avatar,
            builder: (context, value, child) => CircleAvatar(
              radius: 52.5.r,
              backgroundColor: Colors.white,
              child: value != null
                  ? RemoteImage(url: value.fullPath, radius: 1000)
                  : RemoteImage(url: userAvatar, radius: 1000),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: UploadButton(
              loading: _avatarLoading,
              size: 16.r,
              id: "MY_PROFILE_AVATAR",
              onCompleted: (url, id) =>
                  id == "MY_PROFILE_AVATAR" ? _handleChangeAvatar(url) : null,
              icon: FontAwesomeIcons.camera,
              cropStyle: CropStyle.circle,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _coverImage(String converImage) {
    return [
      Container(
        width: double.infinity,
        height: 0.25.sh,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x14000000)),
          boxShadow: highModeShadow,
        ),
        child: ValueListenableBuilder(
          valueListenable: _cover,
          builder: (context, coverImage, child) => AnimatedImage(
            url: coverImage != null ? coverImage.fullPath : converImage,
            errorImage: AppImages.imagePlaceholder,
          ),
        ),
      ),
      Positioned(
        right: 6.w,
        top: 0.25.sh - 16.r * 2 - 6.w,
        child: UploadButton(
          loading: _coverLoading,
          size: 16.r,
          id: "MY_PROFILE_COVER_IMAGE",
          onCompleted: (url, id) =>
              id == "MY_PROFILE_COVER_IMAGE" ? _handleChangePhoto(url) : null,
          icon: FontAwesomeIcons.camera,
        ),
      ),
    ];
  }

  Widget _createPostOption(UserModel user) {
    return Row(
      children: [
        SizedBox(width: py),
        AnimatedImage(
          width: 0.1.sw,
          height: 0.1.sw,
          url: user.avatar?.fullPath ?? "",
          isAvatar: true,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(6.r),
              onTap: () => context.pushNamed(
                Routes.createPost.name,
                extra: {"fromMyProfile": true},
              ),
              child: Container(
                height: 0.1.sw,
                padding: EdgeInsets.only(left: 6.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  'WHATS_ON_YOUR_MIND_TEXT'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: py),
      ],
    );
  }
}
