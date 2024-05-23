import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../pages/search_friend_page.dart';

class FriendSearchButton extends StatelessWidget {
  const FriendSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: context.minBackgroundColor(),
      ),
      onPressed: () => showSearch(
        context: context,
        delegate: FriendSearch(),
        useRootNavigator: true,
      ),
      icon: Icon(Icons.search, size: 24.sp),
    );
  }
}
