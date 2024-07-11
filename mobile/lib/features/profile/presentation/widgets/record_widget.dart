import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/profile/presentation/widgets/audio_card.dart';

class RecordWidget extends StatefulWidget {
  final Function(List<String>) onRecorded;

  const RecordWidget({super.key, required this.onRecorded});

  @override
  State<RecordWidget> createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final recorder = FlutterSoundRecorder();
  bool opened = false;

  final ValueNotifier<List<String>> recordings = ValueNotifier([]);

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  void _handleRecording() async {
    if (!opened) {
      await recorder.openRecorder();
      opened = true;

      recorder.setSubscriptionDuration(Durations.long2);
    }

    if (recorder.isRecording) {
      await stop();
    } else {
      await record();
    }

    setState(() {
      if (mounted) {}
    });
  }

  Future<void> stop() async {
    final url = await recorder.stopRecorder();
    if (url == null) return;

    recordings.value = [...recordings.value, url];
  }

  Future<void> record() async {
    final suffix = DateFormat('yyyyMMddHHmmss', context.locale.languageCode)
        .format(DateTime.now());

    await recorder.startRecorder(
      toFile: 'recording_$suffix.m4a',
      codec: Codec.aacMP4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*  */
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 0.25.sh,
          ),
          child: ValueListenableBuilder(
            valueListenable: recordings,
            builder: (context, value, child) => ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              children: value
                  .map((e) => AudioCard(
                        url: e,
                        isNetwork: false,
                        isFile: true,
                        onDelete: (url) {
                          recordings.value =
                              recordings.value.where((e) => e != url).toList();
                        },
                      ))
                  .toList(),
            ),
          ),
        ),

        /*  */
        const SizedBox(height: 16),
        Row(
          children: [
            Column(
              children: [
                /*  */
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: context.minBackgroundColor(),
                    side: BorderSide.none,
                    padding: const EdgeInsets.all(6),
                  ),
                  onPressed: _handleRecording,
                  child: AnimatedCrossFade(
                    duration: Durations.medium1,
                    firstChild: const Icon(
                      Icons.mic,
                      size: 24,
                      color: AppColors.kPrimaryColor,
                    ),
                    secondChild: const Icon(
                      Icons.stop,
                      size: 24,
                      color: AppColors.kErrorColor,
                    ),
                    crossFadeState: recorder.isRecording
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ),

                /*  */
                StreamBuilder<RecordingDisposition>(
                  stream: recorder.onProgress,
                  builder: (context, snapshot) {
                    final duration = snapshot.data?.duration ?? Duration.zero;

                    String twoDigits(int n) => n.toString().padLeft(2, '0');

                    return Text(
                      '${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
              ],
            ),

            /*  */
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    widget.onRecorded(recordings.value);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("CONFIRM_TEXT".tr()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
