import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/list_schedule/list_schedule_bloc.dart';

import '../widgets/play_video_dialog.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  final ValueNotifier<int> _deleting = ValueNotifier(-1);

  late final _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    _getListSchedule();

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  void _getListSchedule() {
    context.read<ListScheduleBloc>().add(const GetListSchedule(
          size: 15,
          page: 1,
        ));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<ListScheduleBloc>().add(LoadMoreListSchedule(
            page: ++_page,
            size: 15,
          ));
    }
  }

  void _handleDelete(int id) {
    if (_deleting.value > 0) return;

    _deleting.value = id;
    context.read<ListScheduleBloc>().add(DeleteScheduleSubmit(
          videoId: id,
          onSuccess: () => _deleting.value = -1,
          onError: (msg) {
            _deleting.value = -1;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "MY_SCHEDULE_TEXT".tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _getListSchedule,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ListScheduleBloc, ListScheduleState>(
          builder: (context, state) {
            if (state is ListScheduleInitialState ||
                state is ListScheduleInProgressState) {
              return const Center(
                child: AppIndicator(),
              );
            } else if (state is ListScheduleSuccessfulState) {
              _loadingMore = false;
              _hasReachedMax = state.hasReachedMax;

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.schedules.length
                    : state.schedules.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.schedules.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: AppIndicator(size: 32)),
                    );
                  }

                  final schedule = state.schedules[index];

                  return ListTile(
                    onTap: () {},
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: AnimatedImage(
                      url: schedule.target['avatar'].toString().fullPath,
                      isAvatar: true,
                      width: 0.15.sw,
                      height: 0.15.sw,
                    ),
                    title: Text(
                      schedule.target['name'].toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${schedule.repeat == 0 ? "ONCE_TEXT".tr() : "DAILY_TEXT".tr()} | ${Formatter.formatMessageTime(
                        schedule.time,
                        context.locale.languageCode,
                      )}",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => PlayVideoDialog(
                              url: schedule.video['url'].toString(),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _handleDelete(schedule.id),
                          icon: ValueListenableBuilder(
                            valueListenable: _deleting,
                            builder: (context, value, child) =>
                                value == schedule.id
                                    ? const AppIndicator(size: 24)
                                    : const Icon(Icons.delete, size: 24),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: ErrorCard(
                  onRefresh: _getListSchedule,
                  message: (state as ListScheduleFailureState).message,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
