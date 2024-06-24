import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceUtils {
  DeviceUtils._();

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color));
  }

  static bool isLandScapeOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
        enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double getBodyHeight(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return mediaQueryData.size.height -
        (mediaQueryData.padding.top + kToolbarHeight);
  }

  static double getAppBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  static bool isKeyboardVisible(BuildContext context) {
    return View.of(context).viewInsets.bottom > 0;
  }

  static bool isPhysicalDevice() {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty || result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static Future<void> callPhoneNumber(String phoneNumber) async {
    if (phoneNumber == "") return;

    Uri url = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  static Future<void> mailTo(String email) async {
    Uri url = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  static Future<int> getAndroidSdkVersion() async {
    DeviceInfoPlugin _deviceInfo = GetIt.instance<DeviceInfoPlugin>();

    return (await _deviceInfo.androidInfo).version.sdkInt;
  }

  static Future<String> getDeviceID() async {
    DeviceInfoPlugin _deviceInfo = GetIt.instance<DeviceInfoPlugin>();

    String deviceIdentifier = "unknown";

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      deviceIdentifier =
          iosInfo.identifierForVendor ?? "IOS - identifierForVendor - null";
    } else if (kIsWeb) {
      WebBrowserInfo webInfo = await _deviceInfo.webBrowserInfo;
      deviceIdentifier = (webInfo.vendor ?? "WEB - vendor - null") +
          (webInfo.userAgent ?? "WEB - userAgent - null") +
          webInfo.hardwareConcurrency.toString();
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await _deviceInfo.linuxInfo;
      deviceIdentifier = linuxInfo.machineId ?? "Linux - machineId - null";
    }

    return deviceIdentifier;
  }
}
