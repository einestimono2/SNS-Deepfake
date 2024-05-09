import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/color_separate.dart';
import '../widgets/post_card.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  Future<void> _handleRefresh() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      onRefresh: _handleRefresh,
      title: 'Deepfake',
      actions: [
        // const FriendSearchButton(),
        SizedBox(width: 8.w),
      ],
      slivers: [
        /* Create Post Section */
        _buildCreatePostSection(),

        /* Separate */
        const ColorSeparate(),

        /* List Post Section */
        SliverList.separated(
          separatorBuilder: (context, index) =>
              const ColorSeparate(isSliverType: false),
          itemCount: 5,
          itemBuilder: (_, i) => const PostCard(),
        ),
      ],
    );
  }

  Widget _buildCreatePostSection() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          children: [
            /* Avatar - Bloc builder */
            AnimatedImage(
              width: 0.1.sw,
              height: 0.1.sw,
              url:
                  "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/652.jpg",
              isAvatar: true,
            ),

            /* What do you think section */
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6.r),
                  onTap: () => context.goNamed(Routes.createPost.name),
                  child: Container(
                    height: 0.1.sw,
                    padding: EdgeInsets.only(left: 6.w),
                    alignment: Alignment.centerLeft,
                    child: const Text('Bạn đang nghĩ gì?'),
                  ),
                ),
              ),
            ),

            /* Icon image */
            InkWell(
              borderRadius: BorderRadius.circular(3.r),
              onTap: () {},
              child: const Icon(
                Icons.photo_library,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
