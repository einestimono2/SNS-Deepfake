import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/widgets.dart';
import '../widgets/friend_suggest_card.dart';

class SuggestedFriendsPage extends StatefulWidget {
  const SuggestedFriendsPage({super.key});

  @override
  State<SuggestedFriendsPage> createState() => _SuggestedFriendsPageState();
}

class _SuggestedFriendsPageState extends State<SuggestedFriendsPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        /* App Bar */
        const ChildSliverAppBar(title: 'Gợi ý'),

        /* Title */
        SliverToBoxAdapter(
          child: SectionTitle(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            title: "Những người có thể bạn biết",
          ),
        ),

        /* List */
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => SizedBox(height: 22.h),
            itemCount: 3,
            itemBuilder: (_, i) => const FriendSuggestCard(),
          ),
        ),
      ],
    );
  }
}
