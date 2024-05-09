import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';

class ModalListUpload extends StatefulWidget {
  final int? initScrollIdx;
  final List<String> files;
  final Function(int)? onDelete;

  const ModalListUpload({
    super.key,
    this.initScrollIdx,
    required this.files,
    this.onDelete,
  });

  @override
  State<ModalListUpload> createState() => _ModalListUploadState();
}

class _ModalListUploadState extends State<ModalListUpload> {
  final ScrollController _controller = ScrollController();
  late final List<String> _list;

  @override
  void initState() {
    _list = widget.files;

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Scrollable.ensureVisible(
          GlobalObjectKey(widget.files[widget.initScrollIdx ?? 0])
                  .currentContext ??
              context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: context.minBackgroundColor(),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Text(
              "Xong",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.kPrimaryColor),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 12.h,
              children: <Widget>[
                ..._list.map(
                  (e) => Stack(
                    key: GlobalObjectKey(e),
                    children: [
                      fileIsVideo(e)
                          ? SizedBox(
                              width: double.infinity,
                              height: 0.9.sh,
                              child: AppVideo(e),
                            )
                          : Image.file(
                              File(e),
                              width: 1.sw,
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            int idx = widget.files.indexOf(e);
                            widget.onDelete?.call(idx);

                            setState(() {});
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          icon: const Icon(Icons.delete),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 1.sw,
                  height: 12.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
