import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/configs.dart';
import 'core/bloc_observer.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/services.dart';
import 'core/utils/utils.dart';
import 'features/app/app.dart';
import 'features/authentication/authentication.dart';
import 'features/chat/chat.dart';
import 'features/friend/friend.dart';
import 'features/group/group.dart';
import 'features/news_feed/news_feed.dart';
import 'features/profile/profile.dart';
import 'features/search/search.dart';
import 'features/upload/upload.dart';
import 'features/video/video.dart';

Future<void> entryPoint() async {
  await _ensureInitialized();

  _logFlavor();
  _handleSystemError();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      // startLocale: Locale('vi'), // Default: Ngôn ngữ hiện tại của máy
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => di.sl<AppBloc>()..add(AppStarted()),
            ),
            BlocProvider(create: (_) => di.sl<SocketBloc>()),
            BlocProvider(create: (_) => di.sl<UserBloc>()),
            BlocProvider(create: (_) => di.sl<UploadBloc>()),
            BlocProvider(create: (_) => di.sl<DownloadBloc>()),
            BlocProvider(create: (_) => di.sl<MyConversationsBloc>()),
            BlocProvider(create: (_) => di.sl<ConversationDetailsBloc>()),
            BlocProvider(create: (_) => di.sl<MessageBloc>()),
            BlocProvider(create: (_) => di.sl<RequestedFriendsBloc>()),
            BlocProvider(create: (_) => di.sl<SuggestedFriendsBloc>()),
            BlocProvider(create: (_) => di.sl<ListFriendBloc>()),
            BlocProvider(create: (_) => di.sl<FriendActionBloc>()),
            BlocProvider(create: (_) => di.sl<SearchUserBloc>()),
            BlocProvider(create: (_) => di.sl<SearchHistoryBloc>()),
            BlocProvider(create: (_) => di.sl<PostActionBloc>()),
            BlocProvider(create: (_) => di.sl<ListPostBloc>()),
            BlocProvider(create: (_) => di.sl<GroupActionBloc>()),
            BlocProvider(create: (_) => di.sl<ListGroupBloc>()),
            BlocProvider(create: (_) => di.sl<GroupPostBloc>()),
            BlocProvider(create: (_) => di.sl<ProfileActionBloc>()),
            BlocProvider(create: (_) => di.sl<MyPostsBloc>()),
            BlocProvider(create: (_) => di.sl<UserPostsBloc>()),
            BlocProvider(create: (_) => di.sl<UserFriendsBloc>()),
            BlocProvider(create: (_) => di.sl<ListVideoBloc>()),
            BlocProvider(create: (_) => di.sl<ListCommentBloc>()),
          ],
          child: const SnsDeepfakeApp(),
        ),
      ),
    ),
  );
}

Future<void> _ensureInitialized() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = AppBlocObserver();

  await Hive.initFlutter();
  await di.init();

  await Firebase.initializeApp(options: FlavorConfig.instance.firebaseOptions);
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await LocalNotificationService.instance.init();
  await FirebaseNotificationService.instance.init();

  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}

void _logFlavor() {
  final FlavorConfig _flavor = FlavorConfig.instance;

  if (!kReleaseMode) {
    AppLogger.info(
      '🚀 APP FLAVOR_TYPE   : ${_flavor.name}\n🚀 APP API_BASE_URL  : ${_flavor.endpointUrl}',
    );
  }
}

void _handleSystemError() {
  // - [Catch some error]
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  // - [Error Widget]
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
