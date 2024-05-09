import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

class ConversationAvatar extends StatelessWidget {
  final double? size;
  final List<String> avatars;
  final bool isOnline;
  final bool showOnlineStatus;

  const ConversationAvatar({
    super.key,
    this.size,
    required this.avatars,
    required this.isOnline,
    this.showOnlineStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        avatars.length == 1
            ? AnimatedImage(
                width: size ?? 0.165.sw,
                height: size ?? 0.165.sw,
                url: avatars[0],
                isAvatar: true,
              )
            : SizedBox(
                width: size ?? 0.165.sw,
                height: size ?? 0.165.sw,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: AnimatedImage(
                          width: (size ?? 0.165.sw) * 0.65,
                          height: (size ?? 0.165.sw) * 0.65,
                          url: avatars[1],
                          isAvatar: true,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: AnimatedImage(
                          width: (size ?? 0.165.sw) * 0.65,
                          height: (size ?? 0.165.sw) * 0.65,
                          url: avatars[0],
                          isAvatar: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        if (showOnlineStatus)
          isOnline
              ? const Positioned(
                  bottom: 1,
                  right: 1,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 5.5,
                      backgroundColor: Colors.green,
                    ),
                  ))
              : const SizedBox.shrink()
        // Positioned(
        //     bottom: 0,
        //     right: 0,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(6),
        //         color: Theme.of(context).scaffoldBackgroundColor,
        //       ),
        //       padding:
        //           const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        //       child: Text(
        //         "20 phút",
        //         style: Theme.of(context).textTheme.labelMedium?.copyWith(
        //               color: Colors.green,
        //               fontWeight: FontWeight.normal,
        //             ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
