import '../../../config/configs.dart';

extension ImagePath on String {
  String get fullPath => FlavorConfig.instance.baseUrl + this;
}
