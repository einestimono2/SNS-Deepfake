import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/widgets.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      dense: true,
      leading: AnimatedImage(
        width: 0.15.sw,
        height: 0.15.sw,
        url:
            "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/652.jpg",
        isAvatar: true,
      ),
      title: Text(
        "Hữu Khôi Mai",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        '5 bạn chung',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
      ),
      trailing: InkWell(
        borderRadius: BorderRadius.circular(1000),
        onTap: () {},
        child: const Icon(Icons.more_horiz),
      ),
    );
  }
}
