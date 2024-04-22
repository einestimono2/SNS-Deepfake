import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/utils.dart';

class RadioImageButton extends StatelessWidget {
  final int value;
  final String image;
  final bool isSelected;
  final Function(int) onClick;

  const RadioImageButton({
    super.key,
    required this.value,
    required this.image,
    required this.isSelected,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 8,
          shadowColor: context.isLightMode() ? Colors.white24 : Colors.black,
          padding: EdgeInsets.all(8.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          side: BorderSide(
            width: isSelected ? 1.5 : 1,
            color: isSelected ? AppColors.kPrimaryColor : Colors.grey.shade300,
          ),
        ),
        onPressed: () => onClick(value),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    image,
                    width: 0.15.sw,
                    height: 0.15.sw,
                  ),
                ),
                SizedBox(width: 0.015.sw),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(AppMappers.getRoleName(value)),
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: AppColors.kPrimaryColor,
                  size: 18.sp,
                ),
              )
          ],
        ),
      ),
    );
  }
}
