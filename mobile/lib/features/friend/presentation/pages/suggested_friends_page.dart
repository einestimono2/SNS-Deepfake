import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/suggested_friends/suggested_friends_bloc.dart';
import '../widgets/friend_suggest_card.dart';
import '../widgets/shimmer_card.dart';

class SuggestedFriendsPage extends StatefulWidget {
  const SuggestedFriendsPage({super.key});

  @override
  State<SuggestedFriendsPage> createState() => _SuggestedFriendsPageState();
}

class _SuggestedFriendsPageState extends State<SuggestedFriendsPage> {
  late final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
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
        !_loadingMore) {
      _loadingMore = true;

      context.read<SuggestedFriendsBloc>().add(LoadMoreSuggestedFriends(
            size: AppStrings.suggestedFriendsPageSize,
            page: ++_currentPage,
          ));
    }
  }

  Future<void> _getSuggestedFriends() async {
    /* Ngăn call loadmore khi reload do scroll đc gắn vào CustomScrollView nên khi ít thì _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent */
    _loadingMore = true;
    _currentPage = 1;

    context.read<SuggestedFriendsBloc>().add(const GetSuggestedFriends(
          size: AppStrings.suggestedFriendsPageSize,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      onRefresh: _getSuggestedFriends,
      controller: _scrollController,
      title: 'SUGGESTIONS_TEXT'.tr(),
      centerTitle: true,
      slivers: [
        /* Title */
        SliverToBoxAdapter(
          child: SectionTitle(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
            title: "FRIEND_SUGGESTS_TEXT".tr(),
          ),
        ),

        /* List */
        SliverToBoxAdapter(
          child: BlocBuilder<SuggestedFriendsBloc, SuggestedFriendsState>(
            builder: (context, state) {
              if (state is SFInProgressState || state is SFInitialState) {
                return const ShimmerFriendRequestCard(
                  length: AppStrings.suggestedFriendsPageSize,
                );
              } else if (state is SFSuccessfulState) {
                _loadingMore = false;

                return state.friends.isEmpty
                    ? _buildEmptyData()
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 4.h),
                        itemCount: state.hasReachedMax
                            ? state.friends.length
                            : state.friends.length + 1,
                        itemBuilder: (_, idx) => idx < state.friends.length
                            ? FriendSuggestCard(friend: state.friends[idx])
                            : const Center(child: AppIndicator(size: 32)),
                      );
              } else {
                return ErrorCard(
                  onRefresh: _getSuggestedFriends,
                  message: (state as SFFailureState).message,
                );
              }
            },
          ),
        ),

        /*  */
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
            "NO_FRIEND_SUGGESTS_TEXT".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            "NO_FRIEND_SUGGESTS_DESCRIPTION_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
