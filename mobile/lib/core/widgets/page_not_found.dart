import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/configs.dart';
import '../utils/utils.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.pageNotFound,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0.1.sh,
            left: 0.15.sw,
            right: 0.15.sw,
            child: CupertinoButton(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(50),
              onPressed: () => context.goNamed(Routes.newsFeed.name),
              child: Text(
                "BACK_TEXT".tr().toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.4.w,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
