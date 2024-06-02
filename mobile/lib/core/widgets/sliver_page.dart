import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class MainSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const MainSliverAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 0,
      pinned: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge.sectionStyle,
      ),
      actions: actions,
    );
  }
}

class ChildSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const ChildSliverAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      excludeHeaderSemantics: true,
      pinned: true,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall.sectionStyle,
      ),
      actions: actions,
    );
  }
}

class SliverPage extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final double? titleSpacing;
  final List<Widget>? actions;
  final Widget? leading;
  final Future<void> Function()? onRefresh;
  final List<Widget> slivers;
  final ScrollController? controller;
  final ScrollPhysics? physic;
  final bool centerTitle;
  final bool borderBottom;
  final bool floating;
  final Color? backgroundColor;

  const SliverPage({
    super.key,
    this.title,
    this.titleStyle,
    this.titleSpacing,
    this.actions,
    this.leading,
    this.onRefresh,
    required this.slivers,
    this.controller,
    this.physic,
    this.backgroundColor,
    this.centerTitle = false,
    this.borderBottom = false,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget _content = CustomScrollView(
      controller: controller,
      // shrinkWrap: true,
      physics: physic ??
          const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
      slivers: [
        /* App bar */
        SliverAppBar(
          // excludeHeaderSemantics: true,
          bottom: borderBottom
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(0.25),
                  child: Container(
                    height: 0.25,
                    color: context.minBackgroundColor(),
                  ),
                )
              : null,
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          centerTitle: centerTitle,
          elevation: 8,
          titleSpacing: titleSpacing,
          pinned: !floating,
          floating: floating,
          title: title != null
              ? Text(
                  title!,
                  style: titleStyle ??
                      (centerTitle
                          ? Theme.of(context)
                              .textTheme
                              .headlineSmall
                              .sectionStyle
                          : Theme.of(context)
                              .textTheme
                              .headlineLarge
                              .sectionStyle),
                )
              : null,
          leading: leading,
          actions: actions,
        ),

        /* Children */
        ...slivers,

        /* Space with bottom navbar */
        const SliverToBoxAdapter(
          child: SizedBox(height: 6),
        )
      ],
    );

    Widget _body = onRefresh != null
        ? RefreshIndicator.adaptive(
            onRefresh: onRefresh!,
            edgeOffset: kToolbarHeight,
            displacement: 0,
            backgroundColor: context.minBackgroundColor(),
            child: _content,
          )
        : _content;

    return _body;
  }
}
