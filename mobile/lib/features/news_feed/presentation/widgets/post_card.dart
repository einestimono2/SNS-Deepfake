import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/libs/libs.dart';

import '../../../../core/widgets/widgets.dart';
import 'react_button.dart';

final double defaultHorizontal = 16.w;

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Header */
        _buildHeader(context),

        /* Content */
        _buildContent(context),

        /* Stats */
        _buildStats(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: defaultHorizontal, top: 3.h),
      child: Row(
        children: [
          /* Avatar */
          AnimatedImage(
            width: 0.1.sw,
            height: 0.1.sw,
            url:
                "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/652.jpg",
            isAvatar: true,
          ),

          /* Info */
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Vũ trụ Kaizu",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Text(
                        "5 ngày",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 12.sp,
                        child: Text(
                          "\u00b7",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.earthAsia,
                        size: 10.sp,
                        color: Theme.of(context).textTheme.labelMedium!.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /* Icon dot */
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, size: 20.sp),
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        /* Text Section */
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: defaultHorizontal,
            vertical: 3.h,
          ),
          child: const AnimatedSize(
            duration: Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: ReadMoreText(
              """
          What is Lorem Ipsum?
          
          Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
          """,
              trimMode: TrimMode.line,
              trimLines: 4,
              autoHandleOnClick: true,
              trimExpandedText: "",
              trimCollapsedText: "Xem thêm",
              colorClickableText: Colors.grey,
              style: TextStyle(height: 1.15),
            ),
          ),
        ),

        /* Image Section - Không cần padding horizontal */

        /* Video Section - Không cần padding horizontal */
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.thumbsUp,
                size: 12.sp,
                color: Theme.of(context).textTheme.labelMedium?.color,
              ),
              SizedBox(width: 3.w),
              Text("26,2K", style: Theme.of(context).textTheme.labelMedium),
              const Spacer(),
              Text("15,3K bình luận",
                  style: Theme.of(context).textTheme.labelMedium),
              SizedBox(width: 8.w),
              Text("8,1K lượt chia sẻ",
                  style: Theme.of(context).textTheme.labelMedium),
              SizedBox(width: 8.w),
              Text("90.5K lượt xem",
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          SizedBox(height: 6.h),
          const Divider(height: 8, thickness: 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReactButton(
                label: "Thích",
                icon: FontAwesomeIcons.thumbsUp,
                onTap: () {},
              ),
              const ReactButton(
                label: "Bình luận",
                icon: FontAwesomeIcons.comment,
              ),
              const ReactButton(
                label: "Chia sẻ",
                icon: FontAwesomeIcons.share,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
