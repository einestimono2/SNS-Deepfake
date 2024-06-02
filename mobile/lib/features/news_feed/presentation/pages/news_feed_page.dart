import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../blocs/blocs.dart';
import '../widgets/color_separate.dart';
import '../widgets/post_card.dart';
import '../widgets/shimmer_post.dart';

final GlobalKey<NewsFeedPageState> newsFeedPageKey =
    GlobalKey<NewsFeedPageState>();

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => NewsFeedPageState();
}

class NewsFeedPageState extends State<NewsFeedPage> {
  late final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  late int myId;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;

    _getListPost();
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

      context.read<ListPostBloc>().add(LoadMoreListPost(
            groupId: 0,
            page: ++_page,
            size: AppStrings.listPostPageSize,
          ));
    }
  }

  Future<void> _getListPost() async {
    _loadingMore = true;
    _page = 1;

    context.read<ListPostBloc>().add(const GetListPost(
          groupId: 0,
          page: 1,
          size: AppStrings.listPostPageSize,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      controller: _scrollController,
      onRefresh: _getListPost,
      title: 'Deepfake',
      actions: [
        // const FriendSearchButton(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          style: mediumButtonStyle,
        ),
        IconButton(
          onPressed: () => context.pushNamed(Routes.myGroup.name),
          tooltip: "MY_GROUP_TEXT".tr(),
          icon: const Icon(Icons.group),
          style: mediumButtonStyle,
        ),
        SizedBox(width: 6.w),
      ],
      slivers: [
        /* Create Post Section */
        _buildCreatePostSection(),

        /* Separate */
        const ColorSeparate(),

        /* List Post Section */
        SliverToBoxAdapter(
          child: BlocBuilder<ListPostBloc, ListPostState>(
            builder: (context, state) {
              if (state is ListPostInProgressState ||
                  state is ListPostInitialState) {
                return const ShimmerPost(length: 5);
              } else if (state is ListPostSuccessfulState) {
                _loadingMore = false;

                if (state.posts.isEmpty) {
                  return _emptyPost();
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const ColorSeparate(isSliverType: false),
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  itemBuilder: (_, idx) => idx < state.posts.length
                      ? PostCard(
                          post: state.posts[idx],
                          myId: myId,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Center(child: AppIndicator(size: 32)),
                        ),
                );
              } else {
                return ErrorCard(
                  onRefresh: _getListPost,
                  message: (state as ListPostFailureState).message,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _emptyPost() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocalImage(
            width: 0.75.sw,
            height: 0.75.sw,
            fit: BoxFit.contain,
            path: AppImages.emptyDataImage,
          ),
          Text(
            "NO_POST_TITLE_TEXT".tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            "NO_POST_DESCRIPTION_TEXT".tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
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
            GestureDetector(
              onTap: () => context.pushNamed(Routes.myProfile.name),
              child: BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return AnimatedImage(
                    width: 0.1.sw,
                    height: 0.1.sw,
                    url: state.user?.avatar?.fullPath ?? "",
                    isAvatar: true,
                  );
                },
              ),
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
                    child: Text(
                      'WHATS_ON_YOUR_MIND_TEXT'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),

            /* Icon image */
            InkWell(
              borderRadius: BorderRadius.circular(3.r),
              onTap: () => context.goNamed(Routes.createPost.name),
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
