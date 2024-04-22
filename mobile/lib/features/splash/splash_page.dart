import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/utils.dart';
import '../app/app.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final ValueNotifier<bool> isOnline = ValueNotifier(true);
  late Connectivity connectivity;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  initState() {
    connectivity = GetIt.instance<Connectivity>();

    subscription = connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        // Offline
        if (result.contains(ConnectivityResult.none)) {
          if (isOnline.value) isOnline.value = false;
        }
        // Online
        else {
          if (!isOnline.value) {
            isOnline.value = true;
            context.read<AppBloc>().add(AppStarted());
          }
        }
      },
    );

    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppImages.checkInternet,
                width: 0.4.sw,
              ),
              SizedBox(height: 0.025.sh),
              Text(
                "NO_INTERNET".tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 0.25.sh),
              ValueListenableBuilder(
                valueListenable: isOnline,
                builder: (context, value, child) => value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
