import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../pages/search_post.dart';

class PostSearchButton extends StatelessWidget {
  const PostSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: mediumButtonStyle,
      onPressed: () => showSearch(
        context: context,
        delegate: PostSearch(),
        useRootNavigator: true,
      ),
      icon: Icon(Icons.search, size: 22.sp),
    );
  }
}
