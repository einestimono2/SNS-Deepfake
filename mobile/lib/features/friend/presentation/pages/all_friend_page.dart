import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';

class AllFriendPage extends StatefulWidget {
  const AllFriendPage({super.key});

  @override
  State<AllFriendPage> createState() => _AllFriendPageState();
}

class _AllFriendPageState extends State<AllFriendPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          excludeHeaderSemantics: true,
          pinned: true,
          centerTitle: true,
          title: Text(
            'Danh sách bạn bè',
            style: Theme.of(context).textTheme.headlineSmall.sectionStyle,
          ),
        )
      ],
    );
  }
}
