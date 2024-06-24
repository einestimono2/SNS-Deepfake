import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../friend/presentation/widgets/friend_card.dart';
import '../../../friend/presentation/widgets/shimmer_card.dart';
import '../blocs/blocs.dart';

class OtherAllFriendPage extends StatefulWidget {
  final int id;
  final String username;

  const OtherAllFriendPage({
    super.key,
    required this.id,
    required this.username,
  });

  @override
  State<OtherAllFriendPage> createState() => _OtherAllFriendPageState();
}

class _OtherAllFriendPageState extends State<OtherAllFriendPage> {
  late final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  bool _hasReachedMax = false;
  int _currentPage = 1;

  late int myId;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;
    if (context.read<UserFriendsBloc>().state is! UserFriendsSuccessfulState) {
      _getUserFriends();
    }

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

      context.read<UserFriendsBloc>().add(LoadMoreUserFriends(
            size: AppStrings.listFriendPageSize,
            page: ++_currentPage,
            id: widget.id,
          ));
    }
  }

  Future<void> _getUserFriends() async {
    /* Ngăn call loadmore khi reload do scroll đc gắn vào CustomScrollView nên khi ít thì _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent */
    _loadingMore = true;
    _currentPage = 1;

    context.read<UserFriendsBloc>().add(GetUserFriends(
          size: AppStrings.listFriendPageSize,
          page: 1,
          id: widget.id,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "USER_FRIENDS_TEXT".tr(namedArgs: {"name": widget.username}),
      controller: _scrollController,
      centerTitle: true,
      onRefresh: _getUserFriends,
      slivers: [SliverToBoxAdapter(child: _body())],
    );
  }

  Widget _body() {
    return BlocBuilder<UserFriendsBloc, UserFriendsState>(
      builder: (context, state) {
        if (state is UserFriendsFailureState) {
          return SizedBox(
            width: double.infinity,
            height: 0.8.sh,
            child: Center(
              child: ErrorCard(
                onRefresh: _getUserFriends,
                message: state.message,
              ),
            ),
          );
        } else if (state is UserFriendsInProgressState ||
            state is UserFriendsInitialState) {
          return const ShimmerFriendCard(length: 10);
        } else {
          final UserFriendsSuccessfulState _state =
              state as UserFriendsSuccessfulState;
          _loadingMore = false;
          _hasReachedMax = _state.hasReachedMax;

          return Column(
            children: [
              if (_state.totalCount > 0)
                SectionTitle(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  title: "LIST_FRIEND_TEXT".plural(_state.totalCount),
                ),

              /* List */
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _state.hasReachedMax
                    ? _state.friends.length
                    : _state.friends.length + 1,
                itemBuilder: (_, idx) => idx < _state.friends.length
                    ? FriendCard(
                        friend: _state.friends[idx],
                        myId: myId,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: AppIndicator(size: 32)),
                      ),
              )
            ],
          );
        }
      },
    );
  }
}
