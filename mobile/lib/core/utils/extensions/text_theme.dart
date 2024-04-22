import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

extension SectionTextStyle on TextStyle? {
  TextStyle? get sectionStyle => this?.copyWith(
        fontFamily: AppStrings.sectionFont,
        fontWeight: FontWeight.bold,
      );
}
