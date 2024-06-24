import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ErrorCard extends StatelessWidget {
  final String? message;
  final VoidCallback onRefresh;

  const ErrorCard({
    super.key,
    this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRefresh,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 22),
            Text(
              message ?? "SOMETHING_WENT_WRONG_TEXT".tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.kErrorColor),
            ),
            const SizedBox(height: 18),
            SizedBox.square(
              dimension: 48,
              child: Image.asset(AppImages.reloadImage),
            ),
            const SizedBox(height: 6),
            Text(
              "TRY_AGAIN_TEXT".tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.kPrimaryColor),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
