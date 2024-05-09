import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/widgets.dart';
import '../widgets/friend_request_card.dart';

class RequestedFriendsPage extends StatefulWidget {
  const RequestedFriendsPage({super.key});

  @override
  State<RequestedFriendsPage> createState() => _RequestedFriendsPageState();
}

class _RequestedFriendsPageState extends State<RequestedFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        /* AppBar */
        const ChildSliverAppBar(title: 'Lời mời kết bạn'),

        /* Title */
        SliverToBoxAdapter(
          child: SectionTitle(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            title: "Lời mời kết bạn",
            showMoreText: "Sắp xếp",
            onShowMore: () {},
          ),
        ),

        /* List */
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => SizedBox(height: 22.h),
            itemCount: 3,
            itemBuilder: (_, i) => const FriendRequestCard(),
          ),
        ),
      ],
    );
  }
}
