import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/app/app.dart';

import '../bloc/user_bloc.dart';

class FinishForm extends StatefulWidget {
  const FinishForm({super.key});

  @override
  State<FinishForm> createState() => FinishFormState();
}

class FinishFormState extends State<FinishForm> {
  final btnController = AnimatedButtonController();

  final ValueNotifier<String?> _avatar = ValueNotifier(null);
  final ValueNotifier<String?> _cover = ValueNotifier(null);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameFN = FocusNode();
  final _phoneNumberFN = FocusNode();

  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  void _handleFinish() {
    if (_formKey.currentState!.validate() &&
        _usernameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty) {
      final email = context.read<AppBloc>().state.user?.email;

      if (email == null) {
        context.showError(
            message: "[USER] email empty -> Please restart app again!");
        return;
      }

      btnController.play();
      context.read<UserBloc>().add(FinishProfileSubmit(
            username: _usernameController.text,
            phoneNumber: _phoneNumberController.text,
            email: email,
            avatar: _avatar.value,
            coverImage: _cover.value,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is FailureState) {
          btnController.reverse();

          context.showError(
            title: "COMPLETE_PROFILE_ERROR_TITLE_TEXT".tr(),
            message: state.message,
          );
        } else if (state is SuccessfulState) {
          btnController.reverse();
        }
      },
      child: Stack(
        children: [
          /* Cover Image */
          ..._coverImage(),

          /*  */
          Padding(
            padding: EdgeInsets.fromLTRB(0.05.sw, 0.15.sh, 0.05.sw, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Avatar */
                  _avatarImage(),

                  /* Title */
                  SizedBox(height: 0.05.sh),
                  Text(
                    "PERSONAL_INFORMATION_TEXT".tr(),
                    style: Theme.of(context).textTheme.titleLarge.sectionStyle,
                  ),

                  /* Name */
                  SizedBox(height: 0.03.sh),
                  InputFieldWithShadow(
                    onTap: () => _handleTap(_usernameFN, true),
                    onTapOutside: (_) => _handleTap(_usernameFN, false),
                    textInputAction: TextInputAction.next,
                    focusNode: _usernameFN,
                    border: true,
                    title: "FULL_NAME_TEXT".tr(),
                    controller: _usernameController,
                    validator: AppValidations.validateFullName,
                    onFieldSubmitted: (_) => _nextRequest(_phoneNumberFN),
                    prefixIcon: Icon(FontAwesomeIcons.person, size: 18.sp),
                  ),

                  /* Phone number */
                  SizedBox(height: 0.02.sh),
                  InputFieldWithShadow(
                    onTap: () => _handleTap(_phoneNumberFN, true),
                    onTapOutside: (_) => _handleTap(_phoneNumberFN, false),
                    textInputAction: TextInputAction.next,
                    focusNode: _phoneNumberFN,
                    border: true,
                    title: "PHONE_NUMBER_TEXT".tr(),
                    controller: _phoneNumberController,
                    validator: AppValidations.validatePhoneNumber,
                    onFieldSubmitted: (_) => _nextRequest(null),
                    prefixIcon: Icon(FontAwesomeIcons.phone, size: 18.sp),
                  ),

                  /* Button */
                  SizedBox(height: 0.1.sh),
                  Center(
                    child: AnimatedButton(
                      height: 50.h,
                      title: "FINISH_TEXT".tr(),
                      onPressed: _handleFinish,
                      controller: btnController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar _avatarImage() {
    return CircleAvatar(
      backgroundColor: AppColors.kPrimaryColor,
      radius: 54.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: _avatar,
            builder: (context, value, child) => CircleAvatar(
              radius: 52.5.r,
              backgroundColor: Colors.white,
              child: value != null
                  ? RemoteImage(url: value.fullPath, radius: 1000)
                  : const LocalImage(
                      path: AppImages.avatarPlaceholder,
                      radius: 1000,
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: UploadButton(
              size: 16.r,
              id: "AVATAR",
              onCompleted: (url, id) =>
                  id == "AVATAR" ? _avatar.value = url : null,
              icon: FontAwesomeIcons.camera,
              cropStyle: CropStyle.circle,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _coverImage() {
    return [
      Container(
        width: double.infinity,
        height: 0.25.sh,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x14000000)),
          boxShadow: highModeShadow,
        ),
        child: ValueListenableBuilder(
          valueListenable: _cover,
          builder: (context, coverImage, child) => coverImage != null
              ? RemoteImage(url: coverImage.fullPath)
              : const LocalImage(path: AppImages.imagePlaceholder),
        ),
      ),
      Positioned(
        right: 6.w,
        top: 0.25.sh - 16.r * 2 - 6.w,
        child: UploadButton(
          size: 16.r,
          id: "COVER_IMAGE",
          onCompleted: (url, id) =>
              id == "COVER_IMAGE" ? _cover.value = url : null,
          icon: FontAwesomeIcons.camera,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _usernameFN.dispose();
    _phoneNumberFN.dispose();
    super.dispose();
  }

  void _nextRequest(FocusNode? next) {
    _usernameFN.unfocus();
    _phoneNumberFN.unfocus();

    if (next == null) {
      _handleFinish();
    } else {
      next.requestFocus();
    }
  }

  // Set Forcus khi ấn, tại dùng node.hasFocus để xác định loại màu của suffixIcon
  void _handleTap(FocusNode node, bool focus) {
    if (focus) {
      node.requestFocus();
    } else {
      node.unfocus();
    }
  }
}
