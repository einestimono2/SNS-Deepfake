import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/utils.dart';
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
    }

    super.initState();
  }

  @override
  void dispose() {
    socketBloc?.add(CloseConnection());
    // socketBloc?.close();
    super.dispose();
  }

  void _handleChange(int idx) {
    widget.body.goBranch(idx, initialLocation: idx == widget.body.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        if (state.error != null) {
          context.showError(message: state.errorMsg ?? state.error.toString());
        }
      },
      child: Scaffold(
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
          height: 0.1.sh,
          selectedIndex: widget.body.currentIndex,
          onDestinationSelected: _handleChange,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, size: 27.sp),
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
