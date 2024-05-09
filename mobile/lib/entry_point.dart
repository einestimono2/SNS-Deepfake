import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/configs.dart';
import 'core/bloc_observer.dart';
import 'core/di/injection_container.dart' as di;
import 'core/services/services.dart';
import 'core/utils/utils.dart';
import 'features/app/app.dart';
import 'features/authentication/authentication.dart';
import 'features/chat/chat.dart';
import 'features/upload/upload.dart';
import 'firebase_options_development.dart' as firebase_dev_options;
import 'firebase_options_production.dart' as firebase_prod_options;

Future<void> entryPoint({required Flavor flavor}) async {
  await _ensureInitialized(flavor);

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
            BlocProvider(create: (_) => di.sl<MyConversationsBloc>()),
            BlocProvider(create: (_) => di.sl<ConversationDetailsBloc>()),
            BlocProvider(create: (_) => di.sl<MessageBloc>()),
          ],
          child: const SnsDeepfakeApp(),
        ),
      ),
    ),
  );
}

Future<void> _ensureInitialized(Flavor flavor) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp(
    options: flavor == Flavor.development
        ? firebase_dev_options.DefaultFirebaseOptions.currentPlatform
        : firebase_prod_options.DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await LocalNotificationService.instance.init();
  await FirebaseNotificationService.instance.init();

  await dotenv.load(fileName: ".env");
  await _setupFlavor(flavor);
  await di.init();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}

Future<void> _setupFlavor(Flavor flavor) async {
  final url = flavor == Flavor.production
      ? Endpoints.baseProductionUrl
      : Endpoints.baseDevelopmentUrl;

  final socket = flavor == Flavor.production
      ? Endpoints.socketProductionUrl
      : Endpoints.socketDevelopmentUrl;

  final _flavor = FlavorConfig(
    flavor: flavor,
    appTitle: flavor == Flavor.production
        ? AppTexts.appProdTitle
        : AppTexts.appDevTitle,
    endpointUrl: '$url/${Endpoints.prefixEndpoint}',
    baseUrl: url,
    basePrefix: Endpoints.prefixEndpoint,
    socketUrl: socket,
  );

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
