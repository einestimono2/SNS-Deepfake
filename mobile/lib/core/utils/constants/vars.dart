import 'package:flutter/material.dart';

import 'colors.dart';

const lowModeShadow = [
  BoxShadow(
    color: Color(0x07000000),
    blurRadius: 16,
    offset: Offset(0, 16),
    spreadRadius: 0,
  )
];

const highModeShadow = [
  BoxShadow(
    color: Color(0x14000000),
    blurRadius: 30,
    offset: Offset(0, 20),
    spreadRadius: 0,
  )
];

const defaultBorderSide = BorderSide(
  color: AppColors.kPrimaryColor,
  width: 1,
);

final minimumButtonStyle = IconButton.styleFrom(
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

final mediumButtonStyle = IconButton.styleFrom(
  padding: const EdgeInsets.all(4),
  minimumSize: Size.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

customButtonStyle(double radius) => IconButton.styleFrom(
      padding: EdgeInsets.all(radius),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
