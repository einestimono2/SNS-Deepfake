import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';
import '../blocs/list_friend/list_friend_bloc.dart';
import '../widgets/friend_card.dart';
import '../widgets/shimmer_card.dart';

class AllFriendPage extends StatefulWidget {
  const AllFriendPage({super.key});

  @override
  State<AllFriendPage> createState() => _AllFriendPageState();
}

class _AllFriendPageState extends State<AllFriendPage> {
  late final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    _getListFriend();

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

      context.read<ListFriendBloc>().add(LoadMoreListFriend(
            size: AppStrings.listFriendPageSize,
            page: ++_currentPage,
          ));
    }
  }

  Future<void> _getListFriend() async {
    /* Ngăn call loadmore khi reload do scroll đc gắn vào CustomScrollView nên khi ít thì _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent */
    _loadingMore = true;
    _currentPage = 1;

    context.read<ListFriendBloc>().add(const GetListFriend(
          size: AppStrings.listFriendPageSize,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      controller: _scrollController,
      centerTitle: true,
      onRefresh: _getListFriend,
      title: 'YOUR_FRIENDS_TEXT'.tr(),
      slivers: [
        /*  */
        // TODO: Implement search, sort

        /* List Friend */
        SliverToBoxAdapter(
          child: _buildList(),
        ),
      ],
    );
  }

  Widget _buildList() {
    return BlocBuilder<ListFriendBloc, ListFriendState>(
      builder: (context, state) {
        if (state is LFFailureState) {
          return ErrorCard(
            onRefresh: _getListFriend,
            message: state.message,
          );
        }

        int total = 0;
        if (state is LFSuccessfulState) {
          _loadingMore = false;
          total = state.totalCount;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Title */
            if (total > 0)
              SectionTitle(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                title: "LIST_FRIEND_TEXT".plural(total),
                showMoreText: "SORT_TEXT".tr(),
                onShowMore: () {},
              ),

            /* List */
            if (state is LFInProgressState || state is LFInitialState)
              const ShimmerFriendCard(length: AppStrings.listFriendPageSize)
            else if (state is LFSuccessfulState)
              // TODO: Load more indicator + empty data
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 3.h),
                itemCount: state.friends.length,
                itemBuilder: (_, i) => FriendCard(friend: state.friends[i]),
              ),
          ],
        );
      },
    );
  }
}
