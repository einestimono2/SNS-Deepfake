import 'dart:async';

import 'config/configs.dart';
import 'core/utils/utils.dart';
import 'entry_point.dart';

Future<void> main() async {
  // - [run apps] with catch error
  await runZonedGuarded(
    () async {
      await entryPoint(flavor: Flavor.development);
    },
    (error, stackTrace) => AppLogger.error(
      error.toString(),
      error,
      stackTrace,
    ),
  );
}
