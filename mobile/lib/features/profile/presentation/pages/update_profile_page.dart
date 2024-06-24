import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/profile/presentation/presentation.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final btnController = AnimatedButtonController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameFN = FocusNode();
  final _phoneNumberFN = FocusNode();

  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  late String userName;
  late String phoneNumber;

  @override
  void initState() {
    final user = context.read<AppBloc>().state.user!;

    userName = user.username ?? "";
    _usernameController.text = user.username ?? "";
    phoneNumber = user.phoneNumber ?? "";
    _phoneNumberController.text = user.phoneNumber ?? "";

    super.initState();
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate() &&
        _usernameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty) {
      if (_usernameController.text == userName &&
          _phoneNumberController.text == phoneNumber) {
        context.pop();
        return;
      }

      btnController.play();
      context.read<ProfileActionBloc>().add(UpdateProfileSubmit(
            username: _usernameController.text,
            phoneNumber: _phoneNumberController.text,
            onSuccess: () => context.pop(),
            onError: (msg) {
              btnController.reverse();
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  void dispose() {
    _usernameFN.dispose();
    _phoneNumberFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      titleStyle: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
      title: _usernameController.text,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          sliver: SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                  SizedBox(height: 0.05.sh),
                  Center(
                    child: AnimatedButton(
                      height: 44.h,
                      title: "UPDATE_TEXT".tr(),
                      onPressed: _handleUpdate,
                      controller: btnController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _nextRequest(FocusNode? next) {
    _usernameFN.unfocus();
    _phoneNumberFN.unfocus();

    if (next == null) {
      _handleUpdate();
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
