import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_deepfake/core/libs/libs.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/adaptive/app_indicator.dart';

import '../../features/upload/upload.dart';

class UploadButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final double size;
  final Function(String?, String? id) onCompleted;

  /// determine the type of upload
  final UploadType type;

  /// [null] when not apply crop to image
  final CropStyle? cropStyle;

  /// UploadButton's identifier, determines which button to execute in case there are multiple buttons in a screen
  ///
  /// Because all [UploadButton] use the same BLoC
  final String? id;

  const UploadButton({
    super.key,
    this.icon = FontAwesomeIcons.upload,
    required this.size,
    required this.onCompleted,
    this.id,
    this.label,
    this.cropStyle,
    this.type = UploadType.image,
  });

  @override
  UploadButtonState createState() => UploadButtonState();
}

class UploadButtonState extends State<UploadButton> {
  final _fromGallery = 0;
  final _fromCamera = 1;
  String? _fromID;

  final _controller = OverlayPopupController();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  void _handleUpload(int type) async {
    _controller.hideMenu();

    String? path;
    bool crop = widget.cropStyle != null;
    CropStyle cropStyle = widget.cropStyle ?? CropStyle.rectangle;

    if (type == _fromGallery) {
      path = await FileHelper.pickImage(
        crop: crop,
        cropStyle: cropStyle,
      );
    } else {
      path = await FileHelper.pickImage(
        source: ImageSource.camera,
        crop: crop,
        cropStyle: cropStyle,
      );
    }

    if (path != null) {
      _up(path);
    }
  }

  void _up(String path) {
    _loading.value = true;
    _fromID = widget.id; // Xác định nút nào thực hiện upload
    context.read<UploadBloc>().add(UploadImageSubmit(path: path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is SuccessfulState) {
          _loading.value = false;
          widget.onCompleted(state.url, _fromID);
          _fromID =
              null; // Reset lại null để check upload thuộc phần nào ở những lần tiếp
        } else if (state is FailureState) {
          _loading.value = false;
          widget.onCompleted(null, _fromID);
          _fromID =
              null; // Reset lại null để check upload thuộc phần nào ở những lần tiếp

          context.showError(
            title: "UPLOAD_ERROR_TITLE_TEXT".tr(),
            message: state.message,
          );
        }
      },
      child: widget.label != null
          ? _overlay(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6),
                  side: BorderSide.none,
                  backgroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () => _loading.value ? null : _controller.showMenu(),
                icon: ValueListenableBuilder(
                  valueListenable: _loading,
                  builder: (context, value, child) => value
                      ? SizedBox.square(
                          dimension: widget.size,
                          child: const CircularProgressIndicator(),
                        )
                      : Icon(widget.icon, size: widget.size),
                ),
                label: Text(
                  widget.label!,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            )
          : CircleAvatar(
              radius: widget.size,
              backgroundColor: Colors.grey.shade600,
              child: _overlay(
                child: IconButton(
                  onPressed: () =>
                      _loading.value ? null : _controller.showMenu(),
                  splashColor: AppColors.kPrimaryColor,
                  highlightColor: AppColors.kPrimaryColor,
                  enableFeedback: true,
                  tooltip: "UPLOAD_TEXT".tr(),
                  icon: ValueListenableBuilder(
                    valueListenable: _loading,
                    builder: (context, value, child) => value
                        ? const AppIndicator(strokeWidth: 3)
                        : Icon(
                            widget.icon,
                            size: widget.size - 1.5.r,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _overlay({required Widget child}) {
    return OverlayPopup(
      controller: _controller,
      menu: IntrinsicWidth(
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: const Color(0xFF4C4C4C),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              menuItem(
                "GALLERY_TEXT".tr(),
                FontAwesomeIcons.images,
                _fromGallery,
              ),
              menuItem(
                "CAMERA_TEXT".tr(),
                FontAwesomeIcons.camera,
                _fromCamera,
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }

  Widget menuItem(String label, IconData icon, int type) => InkWell(
        // behavior: HitTestBehavior.translucent,
        onTap: () => _handleUpload(type),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 15.sp, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
}
