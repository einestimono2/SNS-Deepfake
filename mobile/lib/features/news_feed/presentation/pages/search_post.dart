import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../search/search.dart';
import '../widgets/color_separate.dart';
import '../widgets/post_card.dart';

class PostSearch extends SearchDelegate {
  Timer? _debounce;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: context.minBackgroundColor(),
        scrolledUnderElevation: 0,
      ),
      textTheme: TextTheme(
        labelLarge:
            Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13.sp),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle:
            Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 13.sp),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showResults(context);
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) {
    return _buildResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Durations.long1, () {
      context.read<SearchPostBloc>().add(SearchPostSubmit(keyword: query));
    });

    return _buildResult();
  }

  BlocBuilder<SearchPostBloc, SearchPostState> _buildResult() {
    return BlocBuilder<SearchPostBloc, SearchPostState>(
      builder: (context, state) {
        if (query.isEmpty) {
          return _buildRecent(context);
        } else if (state is SearchPostInProgressState ||
            state is SearchPostInitialState) {
          return const Center(
            child: AppIndicator(),
          );
        } else if (state is SearchPostSuccessfulState) {
          final myId = context.read<AppBloc>().state.user!.id!;

          return state.posts.isEmpty
              ? _buildEmptyData(context)
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
          print((state as SearchPostFailureState).message);
          return _buildEmptyData(context);
        }
      },
    );
  }

  Widget _buildEmptyData(BuildContext context) {
    return Center(
      child: Text(
        "NO_DATA_TEXT".tr(),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.kErrorColor),
      ),
    );
  }

  Widget _buildRecent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RECENT_TEXT".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () => context
                      .read<SearchHistoryBloc>()
                      .add(const DeleteSearchHistory(
                        type: SearchHistoryType.post,
                        all: true,
                      )),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    "DELETE_ALL_TEXT".tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kErrorColor,
                        ),
                  ),
                )
              ],
            ),

            /*  */
            BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
              builder: (context, state) {
                if (state is! SHSuccessfulState) {
                  return const SizedBox.shrink();
                } else {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: state.postHistories
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              query = e.keyword;
                              context
                                  .read<SearchPostBloc>()
                                  .add(SearchPostSubmit(keyword: query));
                              showResults(context);
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () => context
                                  .read<SearchHistoryBloc>()
                                  .add(DeleteSearchHistory(
                                    keyword: e.keyword,
                                    type: e.type,
                                    all: false,
                                  )),
                              padding: EdgeInsets.zero,
                              backgroundColor: context.minBackgroundColor(),
                              side: BorderSide.none,
                              label: Text(
                                e.keyword,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: context.minTextColor()),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
