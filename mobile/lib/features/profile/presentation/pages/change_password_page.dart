import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/profile_action/profile_action_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _oldObscure = ValueNotifier(true);
  final ValueNotifier<bool> _newObscure = ValueNotifier(true);

  final _curCtl = TextEditingController();
  final _newCtl = TextEditingController();
  final _repeatCtl = TextEditingController();

  final _curFN = FocusNode();
  final _newFN = FocusNode();
  final _repeatFN = FocusNode();

  final btnController = AnimatedButtonController();

  void _handleUpdate() {
    if (_formKey.currentState!.validate() &&
        _curCtl.text.isNotEmpty &&
        _newCtl.text.isNotEmpty & _repeatCtl.text.isNotEmpty) {
      btnController.play();
      context.read<ProfileActionBloc>().add(ChangePasswordSubmit(
            oldPassword: _curCtl.text,
            newPassword: _newCtl.text,
            onSuccess: () {
              btnController.reverse();
            },
            onError: (msg) {
              btnController.reverse();
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  void dispose() {
    _curFN.dispose();
    _newFN.dispose();
    _repeatFN.dispose();
    super.dispose();
  }

  void _nextRequest(FocusNode? next) {
    _curFN.unfocus();
    _newFN.unfocus();
    _repeatFN.unfocus();

    if (next == null) {
      _handleUpdate();
    } else {
      next.requestFocus();
    }
  }

  void _handleTap(FocusNode node, bool focus) {
    if (focus) {
      node.requestFocus();
    } else {
      node.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "CHANGE_PASSWORD_TEXT".tr(),
      centerTitle: true,
      slivers: [
        SliverToBoxAdapter(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _oldObscure,
                    builder: (context, value, child) => Column(
                      children: <Widget>[
                        SectionTitle(
                          title: "CURRENT_PASSWORD_TEXT".tr(),
                          onShowMore: () => _oldObscure.value = !value,
                          showMoreText:
                              value ? "SHOW_TEXT".tr() : "HIDDEN_TEXT".tr(),
                        ),
                        const SizedBox(height: 12),
                        InputFieldWithShadow(
                          onTap: () => _handleTap(_curFN, true),
                          onTapOutside: (_) => _handleTap(_curFN, false),
                          textInputAction: TextInputAction.next,
                          focusNode: _curFN,
                          border: true,
                          obscureText: value,
                          hintText: "OLD_PASSWORD_HINT_TEXT".tr(),
                          controller: _curCtl,
                          validator: AppValidations.validateOldPassword,
                          onFieldSubmitted: (_) => _nextRequest(_newFN),
                        ),
                      ],
                    ),
                  ),

                  /*  */
                  const SizedBox(height: 16),

                  /*  */
                  ValueListenableBuilder(
                    valueListenable: _newObscure,
                    builder: (context, value, child) => Column(
                      children: <Widget>[
                        SectionTitle(
                          title: "NEW_PASSWORD_TEXT".tr(),
                          onShowMore: () => _newObscure.value = !value,
                          showMoreText:
                              value ? "SHOW_TEXT".tr() : "HIDDEN_TEXT".tr(),
                        ),
                        const SizedBox(height: 12),
                        InputFieldWithShadow(
                          onTap: () => _handleTap(_newFN, true),
                          onTapOutside: (_) => _handleTap(_newFN, false),
                          textInputAction: TextInputAction.next,
                          focusNode: _newFN,
                          border: true,
                          obscureText: value,
                          hintText: "NEW_PASSWORD_HINT_TEXT".tr(),
                          controller: _newCtl,
                          validator: (value) =>
                              AppValidations.validateNewPassword(
                            value,
                            _curCtl.text,
                          ),
                          onFieldSubmitted: (_) => _nextRequest(_repeatFN),
                        ),
                        const SizedBox(height: 16),
                        InputFieldWithShadow(
                          onTap: () => _handleTap(_repeatFN, true),
                          onTapOutside: (_) => _handleTap(_repeatFN, false),
                          textInputAction: TextInputAction.next,
                          focusNode: _repeatFN,
                          border: true,
                          obscureText: value,
                          hintText: "REPEAT_PASSWORD_HINT_TEXT".tr(),
                          controller: _repeatCtl,
                          validator: (value) =>
                              AppValidations.validateConfirmPassword(
                            value,
                            _newCtl.text,
                          ),
                          onFieldSubmitted: (_) => _nextRequest(null),
                        ),
                      ],
                    ),
                  ),

                  /* Button */
                  SizedBox(height: 0.1.sh),
                  Center(
                    child: AnimatedButton(
                      height: 50.h,
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
}
