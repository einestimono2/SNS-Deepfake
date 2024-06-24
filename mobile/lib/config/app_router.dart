import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';
import '../features/app/app.dart';
import '../features/authentication/authentication.dart';
import '../features/chat/chat.dart';
import '../features/friend/friend.dart';
import '../features/group/group.dart';
import '../features/news_feed/news_feed.dart';
import '../features/notification/notification.dart';
import '../features/profile/profile.dart';
import '../features/splash/splash.dart';
import '../features/video/video.dart';
import 'configs.dart';

// Private navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

// static final AppRouter _singleton = AppRouter._internal();
// AppRouter._internal();

// late AppBloc appBloc;

// factory AppRouter(AppBloc appBloc) {
//   _singleton.appBloc = appBloc;

//   return _singleton;
// }

class AppRouter {
  static final AppRouter _singleton = AppRouter._internal();
  AppRouter._internal();

  factory AppRouter() => _singleton;

  late final router = GoRouter(
    initialLocation: Routes.splash.path,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: FlavorConfig.isDevelopment(),
    errorBuilder: (context, state) => const PageNotFound(),
    routes: [
      /* Splash Screen --> Xử lý logic, Empty UI do sử dụng native_splash_screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.splash.name,
        path: Routes.splash.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return fadeTransition(
            context: context,
            state: state,
            child: SplashPage(key: state.pageKey),
          );
        },
      ),

      /* Login Screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.login.name,
        path: Routes.login.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return fadeTransition(
            context: context,
            state: state,
            child: LoginPage(key: state.pageKey),
          );
        },
      ),

      /* Sign Up Screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.signup.name,
        path: Routes.signup.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            context: context,
            state: state,
            child: SignUpPage(key: state.pageKey),
          );
        },
      ),

      /* Verify Account Screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.verify.name,
        path: Routes.verify.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return fadeTransition(
            context: context,
            state: state,
            child: VerifyPage(key: state.pageKey),
          );
        },
      ),

      /* Complete Profile Screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.finish.name,
        path: Routes.finish.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return fadeTransition(
            context: context,
            state: state,
            child: FinishPage(key: state.pageKey),
          );
        },
      ),

      /* Forgot Password Screen */
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Routes.forgot.name,
        path: Routes.forgot.path,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return fadeTransition(
            context: context,
            state: state,
            child: ForgotPasswordPage(key: state.pageKey),
          );
        },
      ),

      /* Main Layout */
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: MainLayout(
            key: state.pageKey,
            body: navigationShell,
          ),
        ),
        branches: <StatefulShellBranch>[
          /* News Feed */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.newsFeed.name,
                path: Routes.newsFeed.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return fadeTransition(
                    state: state,
                    context: context,
                    child: NewsFeedPage(key: state.pageKey),
                  );
                },
                routes: [
                  /* Create Post */
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    name: Routes.createPost.name,
                    path: Routes.createPost.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.btt,
                        state: state,
                        context: context,
                        child: CreatePostPage(
                          key: state.pageKey,
                          fromMyProfile: (state.extra
                                  as Map<String, dynamic>?)?['fromMyProfile'] ??
                              false,
                        ),
                      );
                    },
                  ),

                  /* Post Details */
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    name: Routes.postDetails.name,
                    path: Routes.postDetails.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: PostDetailsPage(
                          key: state.pageKey,
                          id: int.parse(state.pathParameters['id']!),
                          focus:
                              (state.extra as Map<String, dynamic>?)?['focus']!,
                        ),
                      );
                    },
                  ),
                ],
              ),

              /* Group */
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.myGroup.name,
                path: Routes.myGroup.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return slideTransition(
                    type: SlideType.rtl,
                    state: state,
                    context: context,
                    child: MyGroupPage(key: state.pageKey),
                  );
                },
                routes: [
                  /* Create Group */
                  GoRoute(
                    name: Routes.createGroup.name,
                    path: Routes.createGroup.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.btt,
                        state: state,
                        context: context,
                        child: CreateGroupPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* Group Details */
                  GoRoute(
                      name: Routes.groupDetails.name,
                      path: Routes.groupDetails.path,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return slideTransition(
                          type: SlideType.rtl,
                          state: state,
                          context: context,
                          child: GroupDetailsPage(
                            key: state.pageKey,
                            id: int.parse(state.pathParameters['id']!),
                            baseInfo: state.extra as Map<String, dynamic>?,
                          ),
                        );
                      },
                      routes: [
                        /* Create Group */
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          name: Routes.createGroupPost.name,
                          path: Routes.createGroupPost.path,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return slideTransition(
                              type: SlideType.btt,
                              state: state,
                              context: context,
                              child: CreateGroupPostPage(
                                key: state.pageKey,
                                groupId: int.parse(state.pathParameters['id']!),
                              ),
                            );
                          },
                        ),

                        /* Manage Group */
                        GoRoute(
                          name: Routes.manageGroup.name,
                          path: Routes.manageGroup.path,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return slideTransition(
                              type: SlideType.rtl,
                              state: state,
                              context: context,
                              child: ManageGroupPage(
                                key: state.pageKey,
                                id: int.parse(state.pathParameters['id']!),
                                isMyGroup: (state.extra
                                    as Map<String, dynamic>)['isMyGroup']!,
                              ),
                            );
                          },
                        ),

                        /* Invite Group */
                        GoRoute(
                          name: Routes.inviteMember.name,
                          path: Routes.inviteMember.path,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return slideTransition(
                              type: SlideType.btt,
                              state: state,
                              context: context,
                              child: InviteMemberPage(
                                key: state.pageKey,
                                id: int.parse(state.pathParameters['id']!),
                              ),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),

          /* Friend */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.friend.name,
                path: Routes.friend.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return fadeTransition(
                    state: state,
                    context: context,
                    child: FriendPage(key: state.pageKey),
                  );
                },
                routes: [
                  /* Suggested Friends */
                  GoRoute(
                    name: Routes.suggestedFriends.name,
                    path: Routes.suggestedFriends.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: SuggestedFriendsPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* Requested Friends */
                  GoRoute(
                    name: Routes.requestedFriends.name,
                    path: Routes.requestedFriends.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: RequestedFriendsPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* All Friends */
                  GoRoute(
                    name: Routes.allFriend.name,
                    path: Routes.allFriend.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: AllFriendPage(key: state.pageKey),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /* Chat */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                  // parentNavigatorKey: shellNavigatorKey,
                  name: Routes.chat.name,
                  path: Routes.chat.path,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return fadeTransition(
                      state: state,
                      context: context,
                      child: ChatPage(key: state.pageKey),
                    );
                  },
                  routes: [
                    /* Conversation - Chat details */
                    GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      name: Routes.conversation.name,
                      path: Routes.conversation.path,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return slideTransition(
                          type: SlideType.rtl,
                          state: state,
                          context: context,
                          child: ConversationPage(
                            key: state.pageKey,
                            id: int.parse(state.pathParameters['id']!),
                            friendData: state.extra == null
                                ? null
                                : state.extra as Map<String, dynamic>,
                          ),
                        );
                      },
                    ),
                  ]),
            ],
          ),

          /* Video */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.video.name,
                path: Routes.video.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return fadeTransition(
                    state: state,
                    context: context,
                    child: VideoPage(key: state.pageKey),
                  );
                },
              ),
            ],
          ),

          /* Notification */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.notification.name,
                path: Routes.notification.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return fadeTransition(
                    state: state,
                    context: context,
                    child: NotificationPage(key: state.pageKey),
                  );
                },
              ),
            ],
          ),

          /* Profile */
          StatefulShellBranch(
            // navigatorKey: shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.profile.name,
                path: Routes.profile.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return fadeTransition(
                    state: state,
                    context: context,
                    child: ProfilePage(key: state.pageKey),
                  );
                },
                routes: [
                  /* Setting */
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    name: Routes.setting.name,
                    path: Routes.setting.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: SettingPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* Update Password */
                  GoRoute(
                    name: Routes.updatePassword.name,
                    path: Routes.updatePassword.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: ChangePasswordPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* Buy Coins */
                  GoRoute(
                    name: Routes.buyCoins.name,
                    path: Routes.buyCoins.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: BuyCoinPage(key: state.pageKey),
                      );
                    },
                  ),

                  /* Video Deepfake */
                  GoRoute(
                      name: Routes.videoDF.name,
                      path: Routes.videoDF.path,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return slideTransition(
                          type: SlideType.rtl,
                          state: state,
                          context: context,
                          child: VideoDeepfakePage(key: state.pageKey),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: Routes.createVideoDF.name,
                          path: Routes.createVideoDF.path,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return slideTransition(
                              type: SlideType.rtl,
                              state: state,
                              context: context,
                              child:
                                  CreateVideoDeepfakePage(key: state.pageKey),
                            );
                          },
                        ),
                      ]),

                  /* My Profile */
                  GoRoute(
                    name: Routes.myProfile.name,
                    path: Routes.myProfile.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: MyProfilePage(key: state.pageKey),
                      );
                    },
                    routes: [
                      /* Update Profile */
                      GoRoute(
                        name: Routes.updateProfile.name,
                        path: Routes.updateProfile.path,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          return slideTransition(
                            type: SlideType.rtl,
                            state: state,
                            context: context,
                            child: UpdateProfilePage(key: state.pageKey),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              /* Other Profile */
              GoRoute(
                // parentNavigatorKey: shellNavigatorKey,
                name: Routes.otherProfile.name,
                path: Routes.otherProfile.path,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return slideTransition(
                    type: SlideType.rtl,
                    state: state,
                    context: context,
                    child: OtherProfilePage(
                      key: state.pageKey,
                      id: int.parse(state.pathParameters['id']!),
                      username:
                          (state.extra as Map<String, dynamic>?)?['username'] ??
                              "",
                    ),
                  );
                },
                routes: [
                  /* All Friends */
                  GoRoute(
                    name: Routes.otherFriends.name,
                    path: Routes.otherFriends.path,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return slideTransition(
                        type: SlideType.rtl,
                        state: state,
                        context: context,
                        child: OtherAllFriendPage(
                          key: state.pageKey,
                          id: int.parse(state.pathParameters['id']!),
                          username: (state.extra
                                  as Map<String, dynamic>?)?['username'] ??
                              "",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final userState = context.read<AppBloc>().state;
      log("[ROUTER] ${state.fullPath}");

      // unauthenticated + splash --> login
      if (userState.authStatus == AuthStatus.unauthenticated &&
          (state.matchedLocation == Routes.splash.path ||
              state.matchedLocation == Routes.profile.path)) {
        return Routes.login.path;
      }

      if (userState.authStatus == AuthStatus.authenticated &&
          userState.user != null) {
        /* 
          Banned: -3,
          Deactivated: -2,
          Pending: -1, // Khi chưa hoàn thiện profile
          Inactive: 0, // Khi chưa xác thực OTP
          Active: 1 // Khi đã hoàn thiện profile
        */
        switch (userState.user!.status) {
          case -1:
            return Routes.finish.path;
          case 0:
            return Routes.verify.path;
          case 1:
            final bool finishing = state.matchedLocation == Routes.finish.path;
            final bool initializing =
                state.matchedLocation == Routes.splash.path;
            final bool logging = state.matchedLocation == Routes.login.path;

            /* Trường hợp khởi động lại app + trường hợp complete profile xong */
            if (finishing || initializing || logging) {
              return userState.user!.token != null
                  ? Routes.newsFeed.path
                  : Routes.login.path;
            }
            /* Trường hợp khi đã ở trong main layout thì k redirect gì cả */
            else {
              return null;
            }
          default:
            return null;
        }
      }

      return null;
    },
    refreshListenable: GoRouterStream(GetIt.instance<AppBloc>().stream),
  );
}

// class GoRouterStreamScope extends InheritedNotifier<GoRouterStream> {
//   GoRouterStreamScope({
//     super.key,
//     required super.child,
//   }) : super(notifier: GoRouterStream(GetIt.instance<AppBloc>().stream));

//   static GoRouterStream of(BuildContext context) => context
//       .dependOnInheritedWidgetOfExactType<GoRouterStreamScope>()!
//       .notifier!;
// }

class GoRouterStream extends ChangeNotifier {
  late final StreamSubscription<AppState> _subscription;

  GoRouterStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (data) {
        if (data.triggerRedirect) {
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

//! Transition
CustomTransitionPage fadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    // transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeIn).animate(animation),
      child: child,
    ),
  );
}

enum SlideType { ltr, rtl, btt, ttb }

CustomTransitionPage slideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  SlideType type = SlideType.ltr,
}) {
  Offset begin = Offset.zero;
  Offset end = Offset.zero;

  switch (type) {
    case SlideType.ltr:
      begin = const Offset(-2.5, 0);
      break;
    case SlideType.rtl:
      begin = const Offset(2.5, 0);
      break;
    case SlideType.btt:
      begin = const Offset(0, 1);
      break;
    case SlideType.ttb:
      begin = const Offset(0, -2.5);
      break;
    default:
      break;
  }

  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    // transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      );
    },
  );
}

/**
 *!- Params:
 * GoRoute(
 *    path: '/sample/:id1/:id2',
 *    name: 'sample',
 *    builder: () => Sample(id1: state.pathParameters['id1'], id2: state.pathParameters['id2']),
 * ), 
 * 
 *!- queryParams
 * GoRoute(
 *    path: '/sample',
 *    name: 'sample',
 *    builder: () => Sample(id1: state.queryParams['id1'], id2: state.queryParams['id2']),
 * ),  
 * 
 * context.namedLocation(
 *    serviceDetailsRouter,
 *    pathParameters: <String, String>{'id': product.id},
 *    queryParams: <String, String>{'sort': 'desc', 'filter': '0'},
 * ),
 */
