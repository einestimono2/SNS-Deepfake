import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/blocs.dart';

class ReportForm extends StatefulWidget {
  final int postId;

  const ReportForm({
    super.key,
    required this.postId,
  });

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _subjectCtl = TextEditingController();
  final TextEditingController _contentCtl = TextEditingController();

  final _subjectFN = FocusNode();
  final _contentFN = FocusNode();

  final btnController = AnimatedButtonController();

  void _handleReport() {
    if (_formKey.currentState!.validate() &&
        _subjectCtl.text.isNotEmpty &&
        _contentCtl.text.isNotEmpty) {
      btnController.play();

      context.read<PostActionBloc>().add(ReportPostSubmit(
            postId: widget.postId,
            subject: _subjectCtl.text,
            content: _contentCtl.text,
            onError: (msg) {
              btnController.reverse();
              context.showError(message: msg);
            },
            onSuccess: () => context.pop(widget.postId),
          ));
    }
  }

  @override
  void dispose() {
    _subjectFN.dispose();
    _contentFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SUBJECT_TEXT".tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _subjectCtl,
                focusNode: _subjectFN,
                onFieldSubmitted: (_) => _contentFN.requestFocus(),
                onTapOutside: (_) => _contentFN.unfocus(),
                validator: AppValidations.validateSubject,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                ),
              ),

              /*  */
              const SizedBox(height: 12),
              Text(
                "CONTENT_TEXT".tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _contentCtl,
                focusNode: _contentFN,
                onFieldSubmitted: (_) => _handleReport(),
                onTapOutside: (_) => _contentFN.unfocus(),
                validator: AppValidations.validateContent,
                minLines: 3,
                maxLines: null,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                ),
              ),

              /*  */
              const SizedBox(height: 22),
              Center(
                child: AnimatedButton(
                  height: 36.h,
                  title: "REPORT_TEXT".tr(),
                  onPressed: _handleReport,
                  controller: btnController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
