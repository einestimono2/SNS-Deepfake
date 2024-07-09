import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/friend/presentation/widgets/friend_search_button.dart';
import 'package:sns_deepfake/features/search/blocs/search_history/search_history_bloc.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../blocs/blocs.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/friend_suggest_card.dart';
import '../widgets/shimmer_card.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final ScrollController _controller = ScrollController();

  late final bool isChildRole;

  @override
  void initState() {
    isChildRole = context.read<AppBloc>().state.user!.role == 0;

    _getRequestedFriends();
    _getSuggestedFriends();

    super.initState();

    /* Gọi danh sách bạn bè trước */
    context.read<ListFriendBloc>().add(const GetListFriend(
          size: AppStrings.listFriendPageSize,
          page: 1,
        ));
  }

  Future<void> _hanldeRefresh() async {
    _getRequestedFriends();
    _getSuggestedFriends();

    context.read<SearchHistoryBloc>().add(GetSearchHistory());
  }

  void _getRequestedFriends() {
    context.read<RequestedFriendsBloc>().add(const GetRequestedFriends(
          size: AppStrings.requestedFriendsPageSize,
          page: 1,
        ));
  }

  void _getSuggestedFriends() {
    context.read<SuggestedFriendsBloc>().add(const GetSuggestedFriends(
          size: AppStrings.suggestedFriendsPageSize,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      onRefresh: _hanldeRefresh,
      title: 'FRIEND_PAGE_TITLE_TEXT'.tr(),
      controller: _controller,
      actions: [
        const FriendSearchButton(),
        SizedBox(width: 6.w),
      ],
      slivers: [
        /* Other Options */
        _buildFriendOptions(context),

        /* Requested Friends */
        SliverToBoxAdapter(
          child: BlocBuilder<RequestedFriendsBloc, RequestedFriendsState>(
            builder: (context, state) {
              if (state is RFFailureState) {
                return ErrorCard(
                  onRefresh: _getRequestedFriends,
                  message: state.message,
                );
              } else {
                return _buildRequestedFriend(state);
              }
            },
          ),
        ),

        /* Suggested Friends */
        SliverToBoxAdapter(
          child: _buildSuggestedFriend(),
        ),

        /*  */
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }

  Widget _buildSuggestedFriend() {
    return BlocBuilder<SuggestedFriendsBloc, SuggestedFriendsState>(
      builder: (context, state) {
        if (state is SFSuccessfulState && state.friends.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Title */
              SectionTitle(
                margin: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 16.h),
                showTopSeparate: true,
                title: "FRIEND_SUGGESTS_TEXT".tr(),
              ),

              /*  */
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 4.h),
                itemCount:
                    state.friends.length > AppStrings.suggestedFriendsPageSize
                        ? AppStrings.suggestedFriendsPageSize
                        : state.friends.length,
                itemBuilder: (_, i) =>
                    FriendSuggestCard(friend: state.friends[i]),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRequestedFriend(RequestedFriendsState state) {
    bool _showSeeMore = (state is RFSuccessfulState) &&
        state.totalCount > AppStrings.requestedFriendsPageSize;
    int total = (state is RFSuccessfulState) ? state.totalCount : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* Title */
        SectionTitle(
          margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          showTopSeparate: true,
          title: "FRIEND_REQUESTS_TEXT".tr() + (total == 0 ? '' : ' ($total)'),
          showMoreText: "SEE_ALL_TEXT".tr(),
          onShowMore: _showSeeMore
              ? () => context.goNamed(isChildRole
                  ? Routes.childRequestedFriends.name
                  : Routes.requestedFriends.name)
              : null,
        ),

        /* List */
        if (state is RFInProgressState || state is RFInitialState)
          const ShimmerFriendRequestCard(
            length: AppStrings.requestedFriendsPageSize,
          )
        else if (state is RFSuccessfulState)
          state.friends.isEmpty
              ? _buildEmptyData()
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemCount:
                      state.friends.length > AppStrings.requestedFriendsPageSize
                          ? AppStrings.requestedFriendsPageSize
                          : state.friends.length,
                  itemBuilder: (_, i) => FriendRequestCard(
                    friend: state.friends[i],
                  ),
                ),

        /* See more button */
        if (_showSeeMore)
          SeeAllButton(
            onClick: () => context.goNamed(isChildRole
                ? Routes.childRequestedFriends.name
                : Routes.requestedFriends.name),
            margin: EdgeInsets.all(16.w),
          ),
      ],
    );
  }

  Widget _buildEmptyData() {
    return Container(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "NO_NEW_REQUESTS_TEXT".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            "NO_NEW_REQUESTS_DESCRIPTION_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildFriendOptions(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Wrap(
          spacing: 8.w,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: context.minBackgroundColor(),
              ),
              onPressed: () => context.goNamed(isChildRole
                  ? Routes.childSuggestedFriends.name
                  : Routes.suggestedFriends.name),
              child: Text(
                "SUGGESTIONS_TEXT".tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: context.minBackgroundColor(),
              ),
              onPressed: () => context.goNamed(isChildRole
                  ? Routes.childAllFriend.name
                  : Routes.allFriend.name),
              child: Text(
                "YOUR_FRIENDS_TEXT".tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
