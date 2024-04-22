import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';
import 'package:sns_deepfake/features/authentication/presentation/widgets/finish_form.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key});

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: null,
        title: Text(
          "COMPLETE_PROFILE_TEXT".tr(),
          style: Theme.of(context).textTheme.headlineSmall.sectionStyle,
        ),
        // backgroundColor: Colors.transparent,
        shadowColor: Colors.black,
        // surfaceTintColor: Colors.transparent,
        // scrolledUnderElevation: 0,
        centerTitle: true,
        elevation: 6.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 1.h),
          child: const FinishForm(),
        ),
      ),
    );
  }
}
