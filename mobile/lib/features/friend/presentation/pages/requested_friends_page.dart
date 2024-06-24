import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/blocs.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/shimmer_card.dart';

class RequestedFriendsPage extends StatefulWidget {
  const RequestedFriendsPage({super.key});

  @override
  State<RequestedFriendsPage> createState() => _RequestedFriendsPageState();
}

class _RequestedFriendsPageState extends State<RequestedFriendsPage> {
  late final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  bool _hasReachedMax = false;
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
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<RequestedFriendsBloc>().add(LoadMoreRequestedFriends(
            size: AppStrings.requestedFriendsPageSize,
            page: ++_currentPage,
          ));
    }
  }

  Future<void> _getRequestedFriends() async {
    /* Ngăn call loadmore khi reload do scroll đc gắn vào CustomScrollView nên khi ít thì _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent */
    _loadingMore = true;
    _currentPage = 1;

    context.read<RequestedFriendsBloc>().add(const GetRequestedFriends(
          size: AppStrings.requestedFriendsPageSize,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "FRIEND_REQUESTS_TEXT".tr(),
      controller: _scrollController,
      centerTitle: true,
      onRefresh: _getRequestedFriends,
      slivers: [
        /* Title */
        SliverToBoxAdapter(
          child: SectionTitle(
            margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
            title: "FRIEND_REQUESTS_TEXT".tr(),
            showMoreText: "SEE_ALL_TEXT".tr(),
          ),
        ),

        /* List */
        SliverToBoxAdapter(
          child: BlocBuilder<RequestedFriendsBloc, RequestedFriendsState>(
            builder: (context, state) {
              if (state is RFInProgressState || state is RFInitialState) {
                return const ShimmerFriendRequestCard(
                  length: AppStrings.requestedFriendsPageSize,
                );
              } else if (state is RFSuccessfulState) {
                _loadingMore = false;
                _hasReachedMax = state.hasReachedMax;

                return state.friends.isEmpty
                    ? _buildEmptyData()
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemCount: state.hasReachedMax
                            ? state.friends.length
                            : state.friends.length + 1,
                        itemBuilder: (_, idx) => idx < state.friends.length
                            ? FriendRequestCard(friend: state.friends[idx])
                            : const Center(child: AppIndicator(size: 32)),
                      );
              } else {
                return ErrorCard(
                  onRefresh: _getRequestedFriends,
                  message: (state as RFFailureState).message,
                );
              }
            },
          ),
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
}
