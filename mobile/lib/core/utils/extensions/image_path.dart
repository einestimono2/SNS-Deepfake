import 'package:sns_deepfake/core/utils/helpers/video_helper.dart';

import '../../../config/configs.dart';

extension ImagePath on String {
  String get fullPath =>
      startsWith("http") ? this : FlavorConfig.instance.baseUrl + this;

  bool get isServerImage =>
      startsWith(FlavorConfig.instance.baseUrl) && !fileIsVideo(this);
  bool get isServerVideo =>
      startsWith(FlavorConfig.instance.baseUrl) && fileIsVideo(this);
}
