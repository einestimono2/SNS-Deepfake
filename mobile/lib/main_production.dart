import 'dart:async';

import 'config/configs.dart';
import 'core/utils/utils.dart';
import 'entry_point.dart';
import 'firebase_options_production.dart' as prod;

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.production,
    appTitle: AppTexts.appProdTitle,
    endpointUrl: '${Endpoints.baseProductionUrl}/${Endpoints.prefixEndpoint}',
    baseUrl: Endpoints.baseProductionUrl,
    basePrefix: Endpoints.prefixEndpoint,
    socketUrl: Endpoints.socketProductionUrl,
    firebaseOptions: prod.DefaultFirebaseOptions.currentPlatform,
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
