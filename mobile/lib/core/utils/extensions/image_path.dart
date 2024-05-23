import '../../../config/configs.dart';

extension ImagePath on String {
  String get fullPath =>
      startsWith("http") ? this : FlavorConfig.instance.baseUrl + this;
}
