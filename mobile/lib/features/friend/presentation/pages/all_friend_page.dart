import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../widgets/friend_card.dart';
import '../widgets/shimmer_friend_card.dart';

class AllFriendPage extends StatefulWidget {
  const AllFriendPage({super.key});

  @override
  State<AllFriendPage> createState() => _AllFriendPageState();
}

class _AllFriendPageState extends State<AllFriendPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        /* AppBar */
        const ChildSliverAppBar(title: 'Danh sách bạn'),

        /* Title */
        SliverToBoxAdapter(
          child: SectionTitle(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            title: "309 bạn bè",
            showMoreText: "Sắp xếp",
            onShowMore: () {},
          ),
        ),

        /* List */
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount: 3,
            itemBuilder: (_, i) =>
                i % 2 == 0 ? const FriendCard() : const ShimmerFriendCard(),
          ),
        ),
      ],
    );
  }
}
