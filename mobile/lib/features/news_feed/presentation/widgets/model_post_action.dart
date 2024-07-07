import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/widgets/adaptive/app_indicator.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/report_form.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';

class ModelPostAction extends StatefulWidget {
  final PostModel post;

  const ModelPostAction(this.post, {super.key});

  @override
  State<ModelPostAction> createState() => _ModelPostActionState();
}

class _ModelPostActionState extends State<ModelPostAction> {
  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);
  final ValueNotifier<bool> _reportLoading = ValueNotifier(false);

  void _handleDelete(BuildContext context) {
    if (_deleteLoading.value || _reportLoading.value) return;

    _deleteLoading.value = true;
    context.read<PostActionBloc>().add(DeletePostSubmit(
          postId: widget.post.id,
          onSuccess: () {
            _deleteLoading.value = false;
            Navigator.of(context, rootNavigator: true).pop();
          },
          onError: (msg) {
            _deleteLoading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  void _handleEdit(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();

    context.pushNamed(
      Routes.editPost.name,
      pathParameters: {"id": widget.post.id.toString()},
    );
  }

  void _handleReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReportForm(
        postId: widget.post.id,
      ),
    ).then(
      (code) {
        if (code != null) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccess(message: "REPORTED_NOTIFICATION".tr());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.post.canEdit;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.minBackgroundColor(),
        ),
        child: Column(
          children: [
            if (isOwner)
              ListTile(
                onTap: () => _handleEdit(context),
                leading: const Icon(FontAwesomeIcons.pen, size: 18),
                title: Text(
                  "ACTION_EDIT_POST_TEXT".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (isOwner)
              ListTile(
                onTap: () => _handleDelete(context),
                leading: ValueListenableBuilder(
                  valueListenable: _deleteLoading,
                  builder: (context, value, child) => value
                      ? const AppIndicator(size: 22)
                      : const Icon(FontAwesomeIcons.trash, size: 20),
                ),
                title: Text(
                  "ACTION_DELETE_POST_TEXT".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (!isOwner)
              ListTile(
                onTap: () => _handleReport(context),
                leading:
                    const Icon(FontAwesomeIcons.circleExclamation, size: 19),
                title: Text(
                  "ACTION_REPORT_POST_TEXT".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                iconColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
          ],
        ),
      ),
    );
  }
}
