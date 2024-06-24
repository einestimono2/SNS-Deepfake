import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/app_image.dart';
import 'package:sns_deepfake/features/app/app.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/comment/comment_card.dart';

import '../../../data/data.dart';
import 'comment_painter.dart';

class CommentTree extends StatefulWidget {
  final CommentModel comment;
  final int authorId;
  final double rootAvatarSize;
  final double childAvatarSize;
  final Color identColor;
  final double identThickness;
  final EdgeInsets childMargin;
  final Function(CommentModel) onReply;
  final bool initExpand;

  const CommentTree({
    super.key,
    required this.comment,
    required this.authorId,
    required this.childAvatarSize,
    required this.rootAvatarSize,
    required this.onReply,
    this.identColor = Colors.white,
    this.identThickness = 1,
    this.childMargin = const EdgeInsets.only(left: 12),
    this.initExpand = true,
  });

  @override
  State<CommentTree> createState() => _CommentTreeState();
}

class _CommentTreeState extends State<CommentTree> {
  late int myId;
  late bool expanded;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;
    expanded = widget.initExpand;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int childLength = widget.comment.nested.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _rootCard(childLength),
        if (childLength > 0)
          AnimatedSize(
            duration: Durations.short4,
            child: expanded
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: childLength,
                    itemBuilder: (context, index) =>
                        _childCard(widget.comment.nested[index]),
                  )
                : _summaryNestedComment(widget.comment.nested[0]),
          ),

        /*  */
        if (childLength > 0 && expanded) _commentCard(),
      ],
    );
  }

  Widget _summaryNestedComment(CommentModel first) {
    return CustomPaint(
      painter: ChildPainter(
        isLast: true,
        rootAvatarSize: widget.rootAvatarSize,
        childAvatarSize: widget.childAvatarSize,
        identColor: widget.identColor,
        identThickness: widget.identThickness,
        childMargin: widget.childMargin,
      ),
      child: Padding(
        padding: widget.childMargin,
        child: GestureDetector(
          onTap: () => setState(() {
            if (mounted) {
              expanded = true;
            }
          }),
          child: Row(
            children: [
              AnimatedImage(
                url: first.author.avatar?.fullPath ?? "",
                isAvatar: true,
                width: widget.childAvatarSize,
                height: widget.childAvatarSize,
              ),
              const SizedBox(width: 8),
              Text(
                first.author.username,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.5.sp),
              ),
              Text(
                " ${"REPLIED_TEXT".tr()}",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 10.5.sp),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 12.sp,
                child: Text(
                  "\u00b7",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 10.5.sp),
                ),
              ),
              Text(
                "NUM_REPLY_TEXT".plural(widget.comment.nested.length),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 10.5.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _childCard(CommentModel _comment) {
    return CustomPaint(
      painter: ChildPainter(
        isLast: false,
        rootAvatarSize: widget.rootAvatarSize,
        childAvatarSize: widget.childAvatarSize,
        identColor: widget.identColor,
        identThickness: widget.identThickness,
        childMargin: widget.childMargin,
      ),
      child: CommentCard(
        margin: widget.childMargin,
        comment: _comment,
        isAuthor: widget.authorId == _comment.author.id,
        avatarSize: widget.childAvatarSize,
        onReply: widget.onReply,
        isNested: true,
      ),
    );
  }

  Widget _commentCard() {
    return CustomPaint(
      painter: ChildPainter(
        isLast: true,
        rootAvatarSize: widget.rootAvatarSize,
        childAvatarSize: widget.childAvatarSize,
        identColor: widget.identColor,
        identThickness: widget.identThickness,
        childMargin: widget.childMargin,
      ),
      child: Padding(
        padding: widget.childMargin.copyWith(),
        child: GestureDetector(
          onTap: () => widget.onReply(widget.comment),
          child: Row(
            children: [
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return AnimatedImage(
                    url: state.user!.avatar?.fullPath ?? "",
                    isAvatar: true,
                    width: widget.childAvatarSize,
                    height: widget.childAvatarSize,
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: context.minBackgroundColor(),
                      width: 1.25,
                    ),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Text(
                    "REPLY_COMMENT_HINT_TEXT".tr(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _rootCard(int childLength) {
    return childLength == 0
        ? CommentCard(
            comment: widget.comment,
            isAuthor: widget.comment.author.id == widget.authorId,
            avatarSize: widget.rootAvatarSize,
            onReply: widget.onReply,
          )
        : CustomPaint(
            painter: RootPainter(
              avatarSize: widget.rootAvatarSize,
              identColor: widget.identColor,
              identThickness: widget.identThickness,
            ),
            child: CommentCard(
              comment: widget.comment,
              isAuthor: widget.comment.author.id == widget.authorId,
              avatarSize: widget.rootAvatarSize,
              onReply: widget.onReply,
            ),
          );
  }
}
