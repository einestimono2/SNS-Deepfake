import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../core/utils/utils.dart';

class CallPage extends StatelessWidget {
  final bool isGroupVideo;
  final String id;
  final String userId;
  final String userName;

  const CallPage({
    super.key,
    required this.isGroupVideo,
    required this.id,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: AppKeys.zegoAppId,
      appSign: AppKeys.zegoAppSign,
      userID: userId,
      userName: userName,
      callID: id,
      config: isGroupVideo
          ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
