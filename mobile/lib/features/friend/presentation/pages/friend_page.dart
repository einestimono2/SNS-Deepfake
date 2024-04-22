import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/friend_request_card.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final ScrollController _controller = ScrollController();

  Future<void> _hanldeRefresh() async {
    print("Refresh");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: _hanldeRefresh,
      edgeOffset: kToolbarHeight,
      displacement: 0,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          /* AppBar */
          _buildAppBar(context),

          /* Other Options */
          _buildFriendOptions(context),

          /* Title */
          SliverToBoxAdapter(
            child: SectionTitle(
              showTopSeparate: true,
              title: "Lời mời kết bạn",
              showMoreText: "Xem tất cả",
              onShowMore: () {},
            ),
          ),

          /* Title */
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(height: 22.h),
              itemCount: 3,
              itemBuilder: (_, i) => const FriendRequestCard(),
            ),
          ),

          /* See more button */
          SliverToBoxAdapter(
            child: SeeAllButton(
              onClick: () {},
              margin: EdgeInsets.all(16.w),
            ),
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
              onPressed: () => context.goNamed(Routes.suggestedFriends.name),
              child: Text(
                "Gợi ý",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: context.minBackgroundColor(),
              ),
              onPressed: () => context.goNamed(Routes.allFriend.name),
              child: Text(
                "Bạn bè",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(
        'Bạn bè',
        style: Theme.of(context).textTheme.headlineLarge.sectionStyle,
      ),
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.minBackgroundColor(),
          ),
          onPressed: () => context.goNamed(Routes.searchFriend.name),
          icon: Icon(Icons.search, size: 24.sp),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
