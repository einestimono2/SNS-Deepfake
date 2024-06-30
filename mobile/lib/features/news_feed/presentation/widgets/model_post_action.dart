import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

import '../../data/data.dart';

class ModelPostAction extends StatelessWidget {
  final PostModel post;

  const ModelPostAction(this.post, {super.key});

  void _handleDelete(BuildContext context) {
    Navigator.pop(context);
  }

  void _handleEdit() {
    //
  }

  void _handleReport(BuildContext context) {
    //
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = post.canEdit;

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
                onTap: _handleEdit,
                leading: const Icon(FontAwesomeIcons.pen, size: 18),
                title: Text(
                  "ACTION_EDIT_POST_TEXT".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (isOwner)
              ListTile(
                onTap: () => _handleDelete(context),
                leading: const Icon(FontAwesomeIcons.trash, size: 20),
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
              ),
          ],
        ),
      ),
    );
  }
}
