import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils.dart';

class FileHelper {
  FileHelper._();

  static Future<List<Permission>> getPermissions(ImageSource? source) async {
    if (source == null) return [];
    List<Permission> _permissions = [];

    if (source == ImageSource.camera) {
      _permissions.add(Permission.camera);
    } else {
      if (DeviceUtils.isIOS()) {
        _permissions.add(Permission.photos);
      } else {
        final sdkVersion = await DeviceUtils.getAndroidSdkVersion();
        if (sdkVersion <= 32) {
          _permissions.add(Permission.storage);
        } else {
          _permissions.add(Permission.photos);
        }
      }
    }

    return _permissions;
  }

  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
    int quality = 100,
    bool crop = false,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    if (await PermissionHelper.request(await getPermissions(source)) == false) {
      return null;
    }

    final _imagePicker = GetIt.instance<ImagePicker>();

    final img = await _imagePicker.pickImage(
      source: source,
      imageQuality: quality,
    );

    if (img == null) {
      return null;
    }

    if (crop) {
      final _imageCropper = GetIt.instance<ImageCropper>();
      final _img = await _imageCropper.cropImage(
          sourcePath: img.path,
          cropStyle: cropStyle,
          compressQuality: 100,
          uiSettings: [
            IOSUiSettings(),
            AndroidUiSettings(),
          ]);

      return _img?.path;
    }

    return img.path;
  }

  static Future<List<XFile>?> pickImages({
    int? limit,
    int quality = 100,
  }) async {
    if (await PermissionHelper.request(
            await getPermissions(ImageSource.gallery)) ==
        false) {
      return null;
    }

    final _imagePicker = GetIt.instance<ImagePicker>();

    final imgs = await _imagePicker.pickMultiImage(
      limit: limit,
      imageQuality: quality,
    );

    return imgs;
  }
  
  static Future<List<XFile>?> pickMultiMedia({
    int? limit,
    int quality = 100,
  }) async {
    if (await PermissionHelper.request(
            await getPermissions(ImageSource.gallery)) ==
        false) {
      return null;
    }

    final _imagePicker = GetIt.instance<ImagePicker>();

    final imgs = await _imagePicker.pickMultipleMedia(
      limit: limit,
      imageQuality: quality,
    );

    return imgs;
  }

  static Future<XFile?> pickVideo({
    ImageSource source = ImageSource.gallery,
    Duration? maxDuration,
  }) async {
    if (await PermissionHelper.request(await getPermissions(source)) == false) {
      return null;
    }

    final _imagePicker = GetIt.instance<ImagePicker>();

    return await _imagePicker.pickVideo(
      source: source,
      maxDuration: maxDuration,
    );
  }
}
