import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
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
import 'core/utils/utils.dart';
import 'features/app/app.dart';
import 'features/authentication/authentication.dart';
import 'features/upload/upload.dart';

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
            BlocProvider(create: (_) => di.sl<UserBloc>()),
            BlocProvider(create: (_) => di.sl<UploadBloc>()),
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

  final _flavor = FlavorConfig(
    flavor: flavor,
    appTitle: flavor == Flavor.production
        ? AppTexts.appProdTitle
        : AppTexts.appDevTitle,
    endpointUrl: '$url/${Endpoints.prefixEndpoint}',
    baseUrl: url,
    basePrefix: Endpoints.prefixEndpoint,
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
