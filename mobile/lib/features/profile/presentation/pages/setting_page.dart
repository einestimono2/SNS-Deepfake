// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      body: SliverPage(
        borderBottom: true,
        title: "Cài đặt hệ thống",
        centerTitle: true,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                BlocBuilder<AppBloc, AppState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () => _handleChangeTheme(context, state.theme),
                      child: ListTile(
                        leading: const Icon(FontAwesomeIcons.palette),
                        title: const Text("Giao diện"),
                        trailing:
                            Text(AppMappers.getThemeName(state.theme.name)),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () => _handleChangeLanguage(context),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.globe),
                    title: const Text("Ngôn ngữ"),
                    trailing: _languageItem(context.locale.languageCode),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _languageItem(String code) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage(code == "vi" ? AppImages.viFlag : AppImages.usFlag),
          radius: 12.r,
        ),
        SizedBox(width: 8.w),
        Text(code == "vi" ? "VI_TEXT".tr() : "EN_TEXT".tr()),
      ],
    );
  }

  void _handleChangeLanguage(BuildContext context) {
    openModalBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 6.h, bottom: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.minBackgroundColor()),
              ),
            ),
            alignment: Alignment.center,
            child: Text("CHANGE_APP_LANGUAGE_TEXT".tr()),
          ),
          InkWell(
            onTap: () => context.pop("vi"),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: const AssetImage(AppImages.viFlag),
                radius: 12.r,
              ),
              title: Text("VI_TEXT".tr()),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.15.sw),
            color: context.minBackgroundColor(),
            height: 0.5,
          ),
          InkWell(
            onTap: () => context.pop("en"),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: const AssetImage(AppImages.usFlag),
                radius: 12.r,
              ),
              title: Text("EN_TEXT".tr()),
            ),
          ),
        ],
      ),
    ).then((value) {
      if (value == null) return;

      String code = context.locale.languageCode;
      if (value != code) context.setLocale(Locale(value));
    });
  }

  void _handleChangeTheme(BuildContext context, ThemeMode current) {
    openModalBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 6.h, bottom: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.minBackgroundColor()),
              ),
            ),
            alignment: Alignment.center,
            child: Text("CHANGE_APP_THEME_TEXT".tr()),
          ),

          /*  */
          RadioListTile.adaptive(
            value: ThemeMode.system,
            title: Text("THEME_SYSTEM_TEXT".tr()),
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: current,
            selected: current == ThemeMode.system,
            activeColor: AppColors.kPrimaryColor,
            onChanged: (value) => context.pop(value),
          ),
          RadioListTile.adaptive(
            value: ThemeMode.light,
            groupValue: current,
            title: Text("THEME_LIGHT_TEXT".tr()),
            controlAffinity: ListTileControlAffinity.trailing,
            selected: current == ThemeMode.light,
            activeColor: AppColors.kPrimaryColor,
            onChanged: (value) => context.pop(value),
          ),
          RadioListTile.adaptive(
            value: ThemeMode.dark,
            groupValue: current,
            title: Text("THEME_DARK_TEXT".tr()),
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (value) => context.pop(value),
            selected: current == ThemeMode.dark,
            activeColor: AppColors.kPrimaryColor,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    ).then((value) {
      if (value == null) return;

      context.read<AppBloc>().add(ChangeTheme(theme: value));
    });
  }
}
