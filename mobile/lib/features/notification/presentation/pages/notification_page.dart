import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';
import 'package:sns_deepfake/core/widgets/sliver_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "NOTIFICATION_TEXT".tr(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: 1.sw,
            height: 0.75.sh,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 0.075.sw),
            child: Text(
              "NO_NOTIFICATION_TEXT".tr(),
              style: Theme.of(context).textTheme.titleLarge.sectionStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
