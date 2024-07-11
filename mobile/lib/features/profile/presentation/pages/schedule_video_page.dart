import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/profile/presentation/widgets/modal_select_child.dart';

import '../../data/data.dart';

class ScheduleVideoPage extends StatefulWidget {
  final int videoId;

  const ScheduleVideoPage({super.key, required this.videoId});

  @override
  State<ScheduleVideoPage> createState() => _ScheduleVideoPageState();
}

class _ScheduleVideoPageState extends State<ScheduleVideoPage> {
  late VideoDeepfakeModel video;

  AnimatedButtonController ctl = AnimatedButtonController();

  ValueNotifier<ShortUserModel?> child = ValueNotifier(null);
  ValueNotifier<int> frequency = ValueNotifier(0);
  final date = TextEditingController(
      text: DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  ).toLocal().toString());

  @override
  void initState() {
    video = (context.read<MyVideoDeepfakeBloc>().state
            as MyVideoDeepfakeSuccessfulState)
        .videos
        .firstWhere((element) => element.id == widget.videoId);

    super.initState();
  }

  void handleSelectChild() {
    openModalBottomSheet(
      context: context,
      child: ModalSelectChild(
        onSelected: (p0) => child.value = p0,
      ),
    );
  }

  void selectDate() async {
    DateTime? _date = await showDatePicker(
      context: context,
      locale: context.locale,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (_date == null) return;

    TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      date.text =
          DateTime(_date.year, _date.month, _date.day, time.hour, time.minute)
              .toLocal()
              .toString();
    }
  }

  void handleCreate() {
    if (child.value == null) {
      context.showError(message: "Children empty");
      return;
    }

    ctl.play();
    context.read<ListScheduleBloc>().add(CreateScheduleSubmit(
          videoId: widget.videoId,
          childId: child.value!.id,
          frequency: frequency.value,
          time: date.text,
          onSuccess: () => context.pop(),
          onError: (msg) {
            ctl.reverse();
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
          "CREATE_SCHEDULE_TEXT".tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppVideo(
                video.url.fullPath,
                isNetwork: true,
              ),

              /*  */
              ValueListenableBuilder(
                valueListenable: child,
                builder: (context, value, child) {
                  return Column(
                    children: <Widget>[
                      SectionTitle(
                        title: "SELECT_CHILD_TEXT".tr(),
                        margin: const EdgeInsets.fromLTRB(12, 18, 12, 12),
                        showMoreText: value == null ? null : "UPDATE_TEXT".tr(),
                        onShowMore: value == null ? null : handleSelectChild,
                      ),

                      /*  */
                      value == null
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              height: 0.2.sh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: context.minBackgroundColor(),
                              ),
                              child: InkWell(
                                onTap: handleSelectChild,
                                borderRadius: BorderRadius.circular(6),
                                child: const Icon(Icons.add, size: 36),
                              ),
                            )
                          : ListTile(
                              leading: AnimatedImage(
                                width: 0.15.sw,
                                height: 0.15.sw,
                                url: value.avatar?.fullPath ?? "",
                              ),
                              title: Text(
                                value.username,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                    ],
                  );
                },
              ),

              /*  */
              SectionTitle(
                title: "TIME_START_TEXT".tr(),
                margin: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: date,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.calendar_today),
                    fillColor: context.minBackgroundColor(),
                    errorBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                ),
              ),

              /*  */
              SectionTitle(
                title: "FREQUENCY_TEXT".tr(),
                margin: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              ),
              ValueListenableBuilder(
                valueListenable: frequency,
                builder: (context, value, child) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () => frequency.value = 0,
                        leading: Radio(
                          value: 0,
                          groupValue: value,
                          onChanged: (_) {},
                        ),
                        title: Text(
                          "ONCE_TEXT".tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        onTap: () => frequency.value = 1,
                        leading: Radio(
                          value: 1,
                          groupValue: value,
                          onChanged: (_) {},
                        ),
                        title: Text(
                          "DAILY_TEXT".tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  );
                },
              ),

              /*  */
              Container(
                margin: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: AnimatedButton(
                  title: "CREATE_TEXT".tr(),
                  onPressed: handleCreate,
                  controller: ctl,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
