import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';
import 'package:sns_deepfake/features/friend/friend.dart';
import 'package:sns_deepfake/features/friend/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../../friend/presentation/presentation.dart';
import '../../../news_feed/presentation/widgets/color_separate.dart';
import '../../../news_feed/presentation/widgets/post_card.dart';
import '../../../news_feed/presentation/widgets/shimmer_post.dart';
import '../widgets/profile_friend_card.dart';
import '../widgets/shimmer_user_friends.dart';
import '../widgets/user_info_card.dart';

class OtherProfilePage extends StatefulWidget {
  final int id;
  final String username;

  const OtherProfilePage({
    super.key,
    required this.id,
    required this.username,
  });

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final double py = 12;
  late int myId;

  late final _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  late ProfileModel profile;

  final ValueNotifier<bool> _friendActionLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _blockActionLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;
    _getUser();

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<UserPostsBloc>().add(LoadMoreUserPosts(
            page: ++_page,
            size: AppStrings.listPostPageSize,
            id: widget.id,
          ));
    }
  }

  Future<void> _getUser() async {
    context.read<ProfileActionBloc>().add(GetUserProfile(widget.id));
  }

  void _handleFriendAction(FriendStatus status, [int? type]) {
    if (status == FriendStatus.respond && type == null) return;
    if (_friendActionLoading.value) return;

    _friendActionLoading.value = true;
    // Hủy kết bạn
    if (status == FriendStatus.accepted) {
      context.read<FriendActionBloc>().add(UnfriendSubmit(
            targetId: widget.id,
            onError: (msg) {
              _friendActionLoading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () {
              context
                  .read<ProfileActionBloc>()
                  .add(UpdateFriendStatus(FriendStatus.none, widget.id));
              _friendActionLoading.value = false;
            },
          ));
    }
    // Phản hồi yêu cầu - confirm
    else if (status == FriendStatus.respond && type == 1) {
      context.read<FriendActionBloc>().add(AcceptRequestSubmit(
            targetId: widget.id,
            onError: (msg) {
              _friendActionLoading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () {
              context
                  .read<ProfileActionBloc>()
                  .add(UpdateFriendStatus(FriendStatus.none, widget.id));
              context
                  .read<RequestedFriendsBloc>()
                  .add(DeleteRequest(widget.id));
              _friendActionLoading.value = false;
            },
          ));
    }
    // Phản hồi yêu cầu - reject
    else if (status == FriendStatus.respond && type == 1) {
      context.read<FriendActionBloc>().add(RefuseRequestSubmit(
            targetId: widget.id,
            onError: (msg) {
              _friendActionLoading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () {
              context
                  .read<ProfileActionBloc>()
                  .add(UpdateFriendStatus(FriendStatus.none, widget.id));
              context
                  .read<RequestedFriendsBloc>()
                  .add(DeleteRequest(widget.id));
              _friendActionLoading.value = false;
            },
          ));
    }
    // Hủy lời mời kết bạn
    else if (status == FriendStatus.sent) {
      context.read<FriendActionBloc>().add(UnsentRequestSubmit(
            targetId: widget.id,
            onError: (msg) {
              _friendActionLoading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () {
              context
                  .read<ProfileActionBloc>()
                  .add(UpdateFriendStatus(FriendStatus.none, widget.id));
              _friendActionLoading.value = false;
            },
          ));
    }
    // Gửi lời mời
    else {
      context.read<FriendActionBloc>().add(SendRequestSubmit(
            targetId: widget.id,
            onError: (msg) {
              _friendActionLoading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () {
              context
                  .read<ProfileActionBloc>()
                  .add(UpdateFriendStatus(FriendStatus.sent, widget.id));
              _friendActionLoading.value = false;
            },
          ));
    }
  }

  void _handleBlockAction(BlockStatus status) {
    if (_blockActionLoading.value || status == BlockStatus.blocked) return;

    _blockActionLoading.value = true;
    if (status == BlockStatus.blocking) {
      context.read<ProfileActionBloc>().add(UnblockSubmit(
            id: widget.id,
            onSuccess: () => _blockActionLoading.value = false,
            onError: (msg) {
              _blockActionLoading.value = false;
              context.showError(message: msg);
            },
          ));
    } else {
      context.read<ProfileActionBloc>().add(BlockSubmit(
            id: widget.id,
            onSuccess: () => _blockActionLoading.value = false,
            onError: (msg) {
              _blockActionLoading.value = false;
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileActionBloc, ProfileActionState>(
      builder: (context, state) {
        return SliverPage(
          onRefresh: _getUser,
          controller: _scrollController,
          title: state is ProfileActionSuccessfulState
              ? state.profile.username
              : widget.username,
          centerTitle: true,
          slivers: [
            if (state is ProfileActionInProgressState ||
                state is ProfileActionInitialState)
              _loading()
            else if (state is ProfileActionSuccessfulState)
              _body(state.profile)
            else
              _error(state as ProfileActionFailureState)
          ],
        );
      },
    );
  }

  Widget _body(ProfileModel profile) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 0.25.sh,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x14000000)),
              boxShadow: highModeShadow,
            ),
            child: AnimatedImage(
              url: profile.coverImage?.fullPath ?? "",
              errorImage: AppImages.imagePlaceholder,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0.25.sh - 54.r, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.kPrimaryColor,
                  radius: 54.r,
                  child: CircleAvatar(
                    radius: 53.r,
                    child: AnimatedImage(
                      url: profile.avatar?.fullPath ?? "",
                      radius: 1000,
                      errorImage: AppImages.avatarPlaceholder,
                    ),
                  ),
                ),

                /*  */
                const SizedBox(height: 8),
                Text(
                  profile.username,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (profile.totalFriends > 0 &&
                    profile.blockStatus != BlockStatus.blocked)
                  Text(
                    "MUTUAL_FRIENDS_TEXT".plural(profile.totalFriends),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                /*  */
                if (profile.blockStatus != BlockStatus.blocked) ...[
                  const SizedBox(height: 18),
                  _buildActionButtons(profile),
                ],

                /*  */
                if (profile.blockStatus != BlockStatus.blocked) ...[
                  const SizedBox(height: 12),
                  const ColorSeparate(isSliverType: false, paddingVertical: 0),
                  UserInfoCard(
                    isMyProfile: false,
                    user: UserModel(
                      role: 0,
                      email: profile.email, // Need
                      phoneNumber: profile.phoneNumber, // Need
                      status: 0,
                    ),
                    paddingHorizontal: py,
                  ),
                ],

                /*  */
                if (profile.blockStatus != BlockStatus.blocked) ...[
                  const SizedBox(height: 12),
                  const ColorSeparate(
                    isSliverType: false,
                    paddingVertical: 0,
                  ),
                  _userFriends(),
                ],

                /*  */
                if (profile.blockStatus != BlockStatus.blocked) ...[
                  const SizedBox(height: 12),
                  const ColorSeparate(
                    isSliverType: false,
                    paddingVertical: 0,
                  ),
                  _userPosts(profile),
                ],
                if (profile.blockStatus == BlockStatus.blocked)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: 0.1.sh,
                      left: 0.1.sw,
                      right: 0.1.sw,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        textAlign: TextAlign.center,
                        "BLOCKED_DESCRIPTION_TEXT".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProfileModel propfile) {
    return Row(
      children: [
        SizedBox(width: py),
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () {
              if (profile.friendStatus == FriendStatus.respond) {
                openModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).pop(1),
                        leading:
                            const Icon(FontAwesomeIcons.userCheck, size: 16),
                        title: Text(
                          "CONFIRM_TEXT".tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      ListTile(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).pop(2),
                        leading:
                            const Icon(FontAwesomeIcons.userXmark, size: 16),
                        title: Text(
                          "DELETE_FRIEND_TEXT".tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                ).then(
                  (value) => _handleFriendAction(propfile.friendStatus, value),
                );
              } else {
                _handleFriendAction(propfile.friendStatus);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: Colors.blue.shade400,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: ValueListenableBuilder(
              valueListenable: _friendActionLoading,
              builder: (context, value, child) => value
                  ? const AppIndicator(size: 16)
                  : Icon(
                      AppMappers.getFriendStatusIcon(propfile.friendStatus),
                      size: 16,
                    ),
            ),
            label: Text(
              AppMappers.getFriendStatusText(propfile.friendStatus),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () => context.pushNamed(
              Routes.conversation.name,
              pathParameters: {"id": propfile.conversationId.toString()},
              extra: {
                "id": widget.id,
                "avatar": propfile.avatar ?? "",
                "username": propfile.username,
              },
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: Colors.grey.shade600,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(FontAwesomeIcons.message, size: 16),
            label: Text(
              "MESSAGE_ACTION_TEXT".tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _handleBlockAction(propfile.blockStatus),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: Colors.red.shade400,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: ValueListenableBuilder(
              valueListenable: _blockActionLoading,
              builder: (context, value, child) => value
                  ? const AppIndicator(size: 16)
                  : Icon(
                      AppMappers.getBlockStatusIcon(propfile.blockStatus),
                      size: 16,
                    ),
            ),
            label: Text(
              AppMappers.getBlockStatusText(propfile.blockStatus),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(6),
        //     ),
        //     backgroundColor: Colors.grey.shade600,
        //     side: BorderSide.none,
        //     padding: const EdgeInsets.all(12),
        //     minimumSize: Size.zero,
        //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //   ),
        //   child: const Icon(FontAwesomeIcons.ellipsis, size: 16),
        // ),
        SizedBox(width: py),
      ],
    );
  }

  Widget _userFriends() {
    const int numCard = 4;
    const double separateSize = 8;
    final double cardWidth =
        (1.sw - py * 2 - separateSize * (numCard - 1)) / numCard;

    return Padding(
      padding: EdgeInsets.only(left: py, right: py),
      child: BlocBuilder<UserFriendsBloc, UserFriendsState>(
        builder: (context, state) {
          int numFriends =
              state is UserFriendsSuccessfulState ? state.totalCount : 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: "PROFILE_FRIENDS_TEXT".tr()),
              if (numFriends > 0)
                Text(
                  "LIST_FRIEND_TEXT".plural(numFriends),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              const SizedBox(height: 16),

              /*  */
              if (state is UserFriendsFailureState)
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ErrorCard(
                    message: state.message,
                    onRefresh: () => context.read<UserFriendsBloc>().add(
                          GetUserFriends(
                            id: widget.id,
                            page: 1,
                            size: AppStrings.listFriendPageSize,
                          ),
                        ),
                  ),
                ),

              /*  */
              if (state is UserFriendsInProgressState ||
                  state is UserFriendsInitialState)
                ShimmerUserFriends(
                  cardWidth: cardWidth,
                  separateWidth: separateSize,
                ),

              /*  */
              if (state is UserFriendsSuccessfulState && numFriends == 0)
                Center(
                  child: NoDataCard(
                    description: "NO_FRIEND_DESCRIPTION_TEXT".tr(),
                    title: "NO_FRIEND_TEXT".tr(),
                  ),
                )
              else if (state is UserFriendsSuccessfulState && numFriends != 0)
                Wrap(
                  spacing: separateSize,
                  runSpacing: 6,
                  children: state.friends
                      .take(numCard * 2)
                      .map((e) => ProfileFriendCard(
                            friendModel: e,
                            width: cardWidth,
                          ))
                      .toList(),
                ),

              /*  */
              if (state is UserFriendsSuccessfulState &&
                  numFriends > numCard * 2)
                SeeAllButton(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  onClick: () => context.pushNamed(
                    Routes.otherFriends.name,
                    pathParameters: {"id": widget.id.toString()},
                    extra: {'username': widget.username},
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _userPosts(ProfileModel user) {
    return Column(
      children: [
        SectionTitle(
          margin: EdgeInsets.only(left: py, right: py, bottom: 8),
          title: "USER_POSTS_TEXT".tr(namedArgs: {'name': user.username}),
        ),

        /*  */
        const SizedBox(height: 6),

        /*  */
        BlocBuilder<UserPostsBloc, UserPostsState>(
          builder: (context, state) {
            if (state is UserPostsInProgressState ||
                state is UserPostsInitialState) {
              return const ShimmerPost(length: 5);
            } else if (state is UserPostsSuccessfulState) {
              _loadingMore = false;
              _hasReachedMax = state.hasReachedMax;

              if (state.posts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: NoDataCard(description: "USER_NO_POSTS_TEXT".tr()),
                  ),
                );
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
                        myId: myId,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: AppIndicator(size: 32)),
                      ),
              );
            } else {
              return ErrorCard(
                onRefresh: () => context.read<UserPostsBloc>().add(GetUserPosts(
                      page: 1,
                      size: AppStrings.listPostPageSize,
                      id: user.id,
                    )),
                message: (state as UserPostsFailureState).message,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _loading() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 0.8.sh,
        child: const Center(
          child: AppIndicator(),
        ),
      ),
    );
  }

  Widget _error(ProfileActionFailureState state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 0.8.sh,
        child: Center(
          child: ErrorCard(
            onRefresh: _getUser,
            message: state.message,
          ),
        ),
      ),
    );
  }
}
