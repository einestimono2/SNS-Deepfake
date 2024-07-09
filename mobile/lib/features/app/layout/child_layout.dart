import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/video/presentation/blocs/blocs.dart';

import '../../../core/utils/utils.dart';
import '../../friend/friend.dart';
import '../../search/blocs/blocs.dart';
import '../bloc/bloc.dart';

class ChildLayout extends StatefulWidget {
  final StatefulNavigationShell body;

  const ChildLayout({
    super.key,
    required this.body,
  });

  @override
  State<ChildLayout> createState() => _ChildLayoutState();
}

class _ChildLayoutState extends State<ChildLayout> {
  @override
  void initState() {
    FlutterNativeSplash.remove();

    super.initState();

    if (context.read<AppBloc>().state.user!.role == 0) {
      _earlyCallApis();
    }
  }

  void _earlyCallApis() {
    context.read<ListVideoBloc>().add(const GetListVideo(
          size: AppStrings.listVideoPageSize,
        ));

    context.read<SearchHistoryBloc>().add(GetSearchHistory());

    context.read<ListFriendBloc>().add(const GetListFriend(
          size: AppStrings.listFriendPageSize,
          page: 1,
        ));
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
        resizeToAvoidBottomInset: widget.body.currentIndex == 0 ? false : true,
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
              icon: const Icon(Icons.ondemand_video_rounded),
              label: "VIDEO_TEXT".tr(),
              tooltip: "VIDEO_TEXT".tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_alt),
              label: "FRIENDS_TEXT".tr(),
              tooltip: "FRIENDS_TEXT".tr(),
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
