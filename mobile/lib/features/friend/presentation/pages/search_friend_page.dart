import 'package:flutter/material.dart';

class SearchFriendPage extends StatefulWidget {
  const SearchFriendPage({super.key});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      slivers: const [
        SliverAppBar(
          excludeHeaderSemantics: true,
          pinned: true,
        )
      ],
    );
  }
}
