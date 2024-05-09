enum Flavor {
  development,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String endpointUrl;
  final String socketUrl;
  final String baseUrl;
  final String basePrefix;
  final String appTitle;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String endpointUrl,
    required String appTitle,
    required String baseUrl,
    required String basePrefix,
    required String socketUrl,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: getFlavorName(flavor.toString()),
      endpointUrl: endpointUrl,
      appTitle: appTitle,
      basePrefix: basePrefix,
      baseUrl: baseUrl,
      socketUrl: socketUrl,
    );

    return _instance;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.endpointUrl,
    required this.appTitle,
    required this.basePrefix,
    required this.baseUrl,
    required this.socketUrl,
  });

  static FlavorConfig get instance => _instance;

  static String getFlavorName(String enumToString) {
    final paths = enumToString.split('.');
    return paths[paths.length - 1];
  }

  static bool isProduction() => _instance.flavor == Flavor.production;

  static bool isDevelopment() => _instance.flavor == Flavor.development;
}
