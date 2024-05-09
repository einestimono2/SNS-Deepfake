import 'dart:async';

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
        // parentNavigatorKey: rootNavigatorKey,
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
                          child: CreatePostPage(key: state.pageKey),
                        );
                      },
                    ),
                  ]),
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
                  ]),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final userState = context.read<AppBloc>().state;
      print("[ROUTER] ${state.fullPath}");

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
  late final StreamSubscription<dynamic> _subscription;

  GoRouterStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
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
