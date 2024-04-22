import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';

class SuggestedFriendsPage extends StatefulWidget {
  const SuggestedFriendsPage({super.key});

  @override
  State<SuggestedFriendsPage> createState() => _SuggestedFriendsPageState();
}

class _SuggestedFriendsPageState extends State<SuggestedFriendsPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: _controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          title: Text(
            'Gợi ý',
            style: Theme.of(context).textTheme.headlineSmall.sectionStyle,
          ),
        )
      ],
    );
  }
}
