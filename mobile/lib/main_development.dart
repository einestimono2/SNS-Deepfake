import 'dart:async';

import 'config/configs.dart';
import 'core/utils/utils.dart';
import 'entry_point.dart';
import 'firebase_options_development.dart' as dev;

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.development,
    appTitle: AppTexts.appDevTitle,
    endpointUrl: '${Endpoints.baseDevelopmentUrl}/${Endpoints.prefixEndpoint}',
    baseUrl: Endpoints.baseDevelopmentUrl,
    basePrefix: Endpoints.prefixEndpoint,
    socketUrl: Endpoints.socketDevelopmentUrl,
    firebaseOptions: dev.DefaultFirebaseOptions.currentPlatform,
  );

  // - [run apps] with catch error
  await runZonedGuarded(
    () async {
      await entryPoint();
    },
    (error, stackTrace) => AppLogger.error(
      error.toString(),
      error,
      stackTrace,
    ),
  );
}
