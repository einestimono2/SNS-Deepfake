import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/utils/constants/colors.dart';

import '../constants/enums.dart';

class AppMappers {
  AppMappers._();

  static String getRoleName(int value) {
    switch (value) {
      case 0:
        return "CHILDREN_TEXT".tr();
      case 1:
        return "PARENT_TEXT".tr();
      default:
        return "";
    }
  }

  static String getThemeName(String themeName) {
    switch (themeName) {
      case "system":
        return "THEME_SYSTEM_TEXT".tr();
      case "light":
        return "THEME_LIGHT_TEXT".tr();
      case "dark":
        return "THEME_DARK_TEXT".tr();
      default:
        return themeName;
    }
  }

  static String getBlockStatusText(BlockStatus status) {
    switch (status) {
      case BlockStatus.blocking:
        return "UN_BLOCK_TEXT".tr();
      default:
        return "BLOCK_TEXT".tr();
    }
  }

  static IconData getBlockStatusIcon(BlockStatus status) {
    switch (status) {
      case BlockStatus.blocking:
        return FontAwesomeIcons.lockOpen;
      default:
        return FontAwesomeIcons.ban;
    }
  }

  static String getFriendStatusText(FriendStatus status) {
    switch (status) {
      case FriendStatus.accepted:
        return "FRIENDS_TEXT".tr();
      case FriendStatus.sent:
        return "FRIEND_STATUS_SENT_TEXT".tr();
      case FriendStatus.respond:
        return "FRIEND_STATUS_RESPOND_TEXT".tr();
      default:
        return "FRIEND_STATUS_ADD_TEXT".tr();
    }
  }

  static IconData getFriendStatusIcon(FriendStatus status) {
    switch (status) {
      case FriendStatus.accepted:
        return FontAwesomeIcons.userCheck;
      case FriendStatus.sent:
        return FontAwesomeIcons.userClock;
      case FriendStatus.respond:
        return FontAwesomeIcons.userGear;
      default:
        return FontAwesomeIcons.userPlus;
    }
  }

  static IconData getReactionIcon(int type) {
    switch (type) {
      case 0:
        return FontAwesomeIcons.solidThumbsDown;
      case 1:
        return FontAwesomeIcons.solidThumbsUp;
      default:
        return FontAwesomeIcons.thumbsUp;
    }
  }

  static String getReactionText(int type) {
    switch (type) {
      case 0:
        return "REACTION_DISLIKE_TEXT".tr();
      default:
        return "REACTION_LIKE_TEXT".tr();
    }
  }

  static Color? getReactionColor(BuildContext context, int type) {
    switch (type) {
      case 0:
        return AppColors.kErrorColor;
      case 1:
        return Colors.blueAccent;
      default:
        return Theme.of(context).textTheme.bodySmall?.color;
    }
  }
}
