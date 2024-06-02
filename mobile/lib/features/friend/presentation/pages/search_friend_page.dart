import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/search/search.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

class FriendSearch extends SearchDelegate {
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
      context.read<SearchUserBloc>().add(SearchUserSubmit(keyword: query));
    });

    return _buildResult();
  }

  BlocBuilder<SearchUserBloc, SearchUserState> _buildResult() {
    return BlocBuilder<SearchUserBloc, SearchUserState>(
      builder: (context, state) {
        if (query.isEmpty) {
          return _buildRecent(context);
        } else if (state is SUInProgressState || state is SUInitialState) {
          return const Center(
            child: AppIndicator(),
          );
        } else if (state is SUSuccessfulState) {
          return state.users.isEmpty
              ? _buildEmptyData(context)
              : ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, idx) => ListTile(
                    onTap: () => context
                      ..pop()
                      ..pushNamed(
                        Routes.otherProfile.name,
                        pathParameters: {"id": state.users[idx].id.toString()},
                      ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    leading: AnimatedImage(
                      isAvatar: true,
                      url: state.users[idx].avatar?.fullPath ?? "",
                    ),
                    subtitle: state.users[idx].sameFriends > 0
                        ? Text(
                            "MUTUAL_FRIENDS_TEXT"
                                .plural(state.users[idx].sameFriends),
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        : null,
                    title: Text(
                      state.users[idx].username ?? "Unknown",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.arrow_forward_rounded),
                  ),
                );
        } else {
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
                        type: SearchHistoryType.user,
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
                    children: state.userHistories
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              query = e.keyword;
                              context
                                  .read<SearchUserBloc>()
                                  .add(SearchUserSubmit(keyword: query));
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
