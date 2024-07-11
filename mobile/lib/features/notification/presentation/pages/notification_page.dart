import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/features/notification/presentation/blocs/list_notification/list_notification_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/blocs.dart';
import '../widgets/notification_card.dart';
import '../widgets/shimmer_notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    _getListNotification();
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

      context.read<ListNotificationBloc>().add(LoadMoreListNotification(
            page: ++_page,
            size: AppStrings.listNotificationPageSize,
          ));
    }
  }

  Future<void> _getListNotification() async {
    _loadingMore = true;
    _page = 1;

    context.read<ListNotificationBloc>().add(const GetListNotification(
          page: 1,
          size: AppStrings.listNotificationPageSize,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "NOTIFICATION_TEXT".tr(),
      controller: _scrollController,
      onRefresh: _getListNotification,
      slivers: [
        SliverToBoxAdapter(
          child: BlocBuilder<ListNotificationBloc, ListNotificationState>(
            builder: (context, state) {
              if (state is ListNotificationInProgressState ||
                  state is ListNotificationInitialState) {
                return const ShimmerNotification(length: 5);
              } else if (state is ListNotificationSuccessfulState) {
                _loadingMore = false;
                _hasReachedMax = state.hasReachedMax;

                if (state.notifications.isEmpty) {
                  return _buildEmptyData();
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, _) => const SizedBox(height: 8),
                  itemCount: state.hasReachedMax
                      ? state.notifications.length
                      : state.notifications.length + 1,
                  itemBuilder: (_, idx) => idx < state.notifications.length
                      ? NotificationCard(
                          notification: state.notifications[idx],
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Center(child: AppIndicator(size: 32)),
                        ),
                );
              } else {
                return ErrorCard(
                  onRefresh: _getListNotification,
                  message: (state as ListNotificationFailureState).message,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyData() {
    return Container(
      width: 1.sw,
      height: 0.75.sh,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 0.075.sw),
      child: Text(
        "NO_NOTIFICATION_TEXT".tr(),
        style: Theme.of(context).textTheme.titleLarge.sectionStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
