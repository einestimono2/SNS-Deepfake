import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../config/configs.dart';
import '../../../core/services/services.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/app/app_bloc.dart';

class SnsDeepfakeApp extends StatefulWidget {
  const SnsDeepfakeApp({super.key});

  @override
  State<SnsDeepfakeApp> createState() => _SnsDeepfakeAppState();
}

class _SnsDeepfakeAppState extends State<SnsDeepfakeApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseNotificationService.instance.requestNotificationPermission();
    });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => MaterialApp.router(
        title: FlavorConfig.instance.appTitle,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: state.theme,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
