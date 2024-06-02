import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/color_separate.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../../authentication/data/data.dart';
import '../../../friend/friend.dart';
import '../widgets/profile_friend_card.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ValueNotifier<String?> _avatar = ValueNotifier(null);
  final ValueNotifier<String?> _cover = ValueNotifier(null);

  final double py = 12.0;

  @override
  void initState() {
    if (context.read<ListFriendBloc>().state is! LFSuccessfulState) {
      context.read<ListFriendBloc>().add(const GetListFriend(
            page: 1,
            size: AppStrings.listFriendPageSize,
          ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => SliverPage(
        title: state.user?.username ?? state.user?.email ?? "PROFILE_TEXT".tr(),
        titleStyle: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
        titleSpacing: 0,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                /* Cover Image */
                ..._coverImage(state.user?.coverImage?.fullPath ?? ""),

                /*  */
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0.25.sh - 54.r, 0, 0),
                  child: Column(
                    children: [
                      _avatarImage(state.user?.avatar?.fullPath ?? ""),
                      const SizedBox(height: 16),
                      Text(
                        state.user?.username ?? state.user?.email ?? "",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      /*  */
                      const SizedBox(height: 12),
                      const ColorSeparate(
                        isSliverType: false,
                        paddingVertical: 0,
                      ),

                      /*  */
                      _userInfo(state.user!),
                      _userFriends(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo(UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: py),
      child: Column(
        children: [
          SectionTitle(
            title: "PROFILE_DETAILS_TEXT".tr(),
            onShowMore: () {},
            showMoreText: "UPDATE_TEXT".tr(),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.email, "EMAIL_TEXT".tr(), user.email),
          const SizedBox(height: 4),
          Divider(
            thickness: 0.25,
            height: 1,
            color: context.minBackgroundColor(),
          ),
          const SizedBox(height: 4),
          _infoRow(
            Icons.phone,
            "PHONE_NUMBER_TEXT".tr(),
            user.phoneNumber.toString(),
          ),
        ],
      ),
    );
  }

  Widget _userFriends() {
    const int numCard = 4;
    const double separateSize = 8;
    final double cardWidth =
        (1.sw - py * 2 - separateSize * (numCard - 1)) / numCard;

    return Padding(
      padding: EdgeInsets.only(left: py, right: py, top: 18),
      child: BlocBuilder<ListFriendBloc, ListFriendState>(
        builder: (context, state) {
          int numFriends = state is LFSuccessfulState ? state.totalCount : 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                showTopSeparate: true,
                title: "PROFILE_FRIENDS_TEXT".tr(),
                onShowMore: () => context.goNamed(Routes.friend.name),
                showMoreText: "FIND_FRIEND_TEXT".tr(),
              ),
              if (numFriends != 0)
                Text(
                  "LIST_FRIEND_TEXT".plural(numFriends),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              const SizedBox(height: 16),
              if (state is LFSuccessfulState && numFriends == 0)
                Center(
                  child: NoDataCard(
                    description: "NO_FRIEND_DESCRIPTION_TEXT".tr(),
                    title: "NO_FRIEND_TEXT".tr(),
                  ),
                ),
              if (state is LFSuccessfulState && numFriends != 0)
                Wrap(
                  spacing: separateSize,
                  runSpacing: 6,
                  children: state.friends
                      .take(numCard * 2)
                      .map((e) => ProfileFriendCard(
                            friendModel: e,
                            width: cardWidth,
                          ))
                      .toList(),
                ),
              if (state is LFSuccessfulState && numFriends > numCard * 2)
                SeeAllButton(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  onClick: () => context.pushNamed(Routes.allFriend.name),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String text) {
    return Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: 0.35.sw,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 14.sp,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  CircleAvatar _avatarImage(String userAvatar) {
    return CircleAvatar(
      backgroundColor: AppColors.kPrimaryColor,
      radius: 54.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: _avatar,
            builder: (context, value, child) => CircleAvatar(
              radius: 52.5.r,
              backgroundColor: Colors.white,
              child: value != null
                  ? RemoteImage(url: value.fullPath, radius: 1000)
                  : RemoteImage(url: userAvatar, radius: 1000),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: UploadButton(
              size: 16.r,
              id: "MY_PROFILE_AVATAR",
              onCompleted: (url, id) =>
                  id == "MY_PROFILE_AVATAR" ? _avatar.value = url : null,
              icon: FontAwesomeIcons.camera,
              cropStyle: CropStyle.circle,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _coverImage(String converImage) {
    return [
      Container(
        width: double.infinity,
        height: 0.25.sh,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x14000000)),
          boxShadow: highModeShadow,
        ),
        child: ValueListenableBuilder(
          valueListenable: _cover,
          builder: (context, coverImage, child) => coverImage != null
              ? RemoteImage(url: coverImage.fullPath)
              : RemoteImage(url: converImage),
        ),
      ),
      Positioned(
        right: 6.w,
        top: 0.25.sh - 16.r * 2 - 6.w,
        child: UploadButton(
          size: 16.r,
          id: "MY_PROFILE_COVER_IMAGE",
          onCompleted: (url, id) =>
              id == "MY_PROFILE_COVER_IMAGE" ? _cover.value = url : null,
          icon: FontAwesomeIcons.camera,
        ),
      ),
    ];
  }
}
