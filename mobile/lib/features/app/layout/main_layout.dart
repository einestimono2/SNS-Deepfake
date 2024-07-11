import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/video/presentation/blocs/blocs.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../core/utils/utils.dart';
import '../../chat/chat.dart';
import '../../friend/friend.dart';
import '../../search/blocs/blocs.dart';
import '../bloc/bloc.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell body;

  const MainLayout({
    super.key,
    required this.body,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final int? userId;
  SocketBloc? socketBloc;

  @override
  void initState() {
    FlutterNativeSplash.remove();

    userId = context.read<AppBloc>().state.user?.id;
    if (userId == null) {
      AppLogger.error("[main_layout] userId - null");
    } else {
      socketBloc = context.read<SocketBloc>();
      socketBloc?.add(OpenConnection(userId: userId!));

      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: AppKeys.zegoAppId,
        appSign: AppKeys.zegoAppSign,
        userID: userId.toString(),
        userName: context.read<AppBloc>().state.user!.username!,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    }

    super.initState();

    if (context.read<AppBloc>().state.user!.role != 0) {
      _earlyCallApis();
    }
  }

  @override
  void dispose() {
    socketBloc?.add(CloseConnection());
    // socketBloc?.close();
    super.dispose();
  }

  void _earlyCallApis() {
    context.read<MyConversationsBloc>().add(const GetMyConversations(
          page: 1,
          size: AppStrings.conversationPageSize,
        ));

    context.read<ListVideoBloc>().add(const GetListVideo(
          size: AppStrings.listVideoPageSize,
        ));

    context.read<SearchHistoryBloc>().add(GetSearchHistory());

    context.read<ListFriendBloc>().add(const GetListFriend(
          size: AppStrings.listFriendPageSize,
          page: 1,
        ));

    context.read<MyChildrenBloc>().add(GetMyChildren());
  }

  void _handleChange(int idx) {
    // print("====> ${widget.body.route.branches[0].defaultRoute?.path}");
    // print("====> ${widget.body.shellRouteContext.routerState.matchedLocation}");

    widget.body.goBranch(idx, initialLocation: idx == widget.body.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocketBloc, SocketState>(
      listenWhen: (previous, current) => previous.errorMsg != current.errorMsg,
      listener: (context, state) {
        if (state.errorMsg != null) {
          context.showError(message: state.errorMsg!);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: widget.body.currentIndex == 3 ? false : true,
        body: SafeArea(
          child: widget.body,
        ),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color:
                  context.isDarkMode() ? Colors.black26 : Colors.grey.shade300,
              spreadRadius: 0.5,
              blurRadius: 0.5,
            ),
          ],
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 500),
          height: AppSizes.bottomNavBarHeight,
          selectedIndex: widget.body.currentIndex,
          onDestinationSelected: _handleChange,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, size: 26.sp),
              label: "HOME_TEXT".tr(),
              tooltip: "HOME_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_alt),
              label: "FRIENDS_TEXT".tr(),
              tooltip: "FRIENDS_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.message_rounded),
              label: "MESSAGE_TEXT".tr(),
              tooltip: "MESSAGE_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.ondemand_video_rounded),
              label: "VIDEO_TEXT".tr(),
              tooltip: "VIDEO_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications),
              label: "NOTIFICATION_TEXT".tr(),
              tooltip: "NOTIFICATION_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_2),
              label: "PROFILE_TEXT".tr(),
              tooltip: "PROFILE_TEXT".tr(),
            ),
          ],
        ),
      ),
    );
  }
}


  // Widget _bottomNavBar() {
  //   return SafeArea(
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         boxShadow: highModeShadow,
  //         border: Border(
  //           top: BorderSide(
  //             width: 0.25,
  //             color: Colors.black12,
  //           ),
  //         ),
  //       ),
  //       child: BottomNavigationBar(
  //         type: BottomNavigationBarType.shifting,
  //         selectedFontSize: 10.5.sp,
  //         unselectedFontSize: 10.sp,
  //         iconSize: 26.sp,
  //         currentIndex: body.currentIndex,
  //         elevation: 10,
  //         onTap: _handleChange,
  //         items: [
  //           BottomNavigationBarItem(
  //             icon: Icon(Icons.home, size: 27.sp),
  //             label: "HOME_TEXT".tr(),
  //             tooltip: "HOME_TEXT".tr(),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: const Icon(Icons.people_alt),
  //             label: "FRIENDS_TEXT".tr(),
  //             tooltip: "FRIENDS_TEXT".tr(),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: const Icon(Icons.message_rounded),
  //             label: "MESSAGE_TEXT".tr(),
  //             tooltip: "MESSAGE_TEXT".tr(),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: const Icon(Icons.ondemand_video_rounded),
  //             label: "VIDEO_TEXT".tr(),
  //             tooltip: "VIDEO_TEXT".tr(),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: const Icon(Icons.notifications),
  //             label: "NOTIFICATION_TEXT".tr(),
  //             tooltip: "NOTIFICATION_TEXT".tr(),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: const Icon(Icons.person_2),
  //             label: "PROFILE_TEXT".tr(),
  //             tooltip: "PROFILE_TEXT".tr(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
