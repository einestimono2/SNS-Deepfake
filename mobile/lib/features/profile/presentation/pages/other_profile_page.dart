import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/widgets/widgets.dart';

class OtherProfilePage extends StatelessWidget {
  final int id;

  const OtherProfilePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "User $id",
      centerTitle: true,
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Text("User $id"),
          ),
        ),
      ],
    );
  }
}
