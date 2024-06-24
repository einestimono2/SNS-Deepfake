import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/extensions/image_path.dart';

import '../../features/group/group.dart';
import 'widgets.dart';

class SelectGroupCard extends StatefulWidget {
  final List<GroupModel> groups;
  final int myId;
  final int currentSelected;
  final String titleText;
  final String btnText;

  const SelectGroupCard({
    super.key,
    required this.groups,
    required this.myId,
    required this.titleText,
    required this.btnText,
    this.currentSelected = 0,
  });

  @override
  State<SelectGroupCard> createState() => _SelectGroupCardState();
}

class _SelectGroupCardState extends State<SelectGroupCard> {
  late final ValueNotifier<int> _idx;

  @override
  void initState() {
    _idx = ValueNotifier(widget.currentSelected);

    super.initState();
  }

  void _handleChange(int? idx) {
    if (idx != null) _idx.value = idx;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.titleText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          /*  */
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 0.5.sh,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ValueListenableBuilder(
                valueListenable: _idx,
                builder: (context, value, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _publicGroup(value),
                    if (widget.groups.isNotEmpty)
                      ...widget.groups.map((e) => _group(e, value))
                  ],
                ),
              ),
            ),
          ),

          /*  */
          ElevatedButton(
            onPressed: () => context.pop(_idx.value),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                widget.btnText,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  RadioListTile<int> _publicGroup(int idx) {
    return RadioListTile.adaptive(
      contentPadding: const EdgeInsets.only(right: 12),
      dense: true,
      value: 0,
      groupValue: idx,
      onChanged: _handleChange,
      title: Text(
        "Public",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        "All group",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      useCupertinoCheckmarkStyle: true,
    );
  }

  RadioListTile<int> _group(GroupModel group, int idx) {
    return RadioListTile.adaptive(
      contentPadding: const EdgeInsets.only(right: 12),
      dense: true,
      value: group.id,
      groupValue: idx,
      onChanged: _handleChange,
      title: Text(
        group.groupName ?? "",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: group.description == null
          ? null
          : Text(
              group.description!,
              style: Theme.of(context).textTheme.labelMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
      useCupertinoCheckmarkStyle: true,
      secondary: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...group.members.take(4).map(
                (e) => Align(
                  widthFactor: 0.5,
                  child: AnimatedImage(
                    height: 16,
                    width: 16,
                    isAvatar: true,
                    url: e.avatar?.fullPath ?? "",
                  ),
                ),
              ),

          /*  */
          if (group.members.length > 4)
            Align(
              widthFactor: 0.5,
              child: Container(
                height: 16,
                width: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  "+${group.members.length - 4}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 9,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
