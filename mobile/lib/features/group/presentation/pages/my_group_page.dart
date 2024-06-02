import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../data/data.dart';
import '../blocs/blocs.dart';
import '../widgets/group_card.dart';

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({super.key});

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  final ScrollController _controller = ScrollController();

  Future<void> _getMyGroups() async {
    context.read<ListGroupBloc>().add(const GetMyGroups());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListGroupBloc, ListGroupState>(
      listener: (context, state) {
        if (state is ListGroupFailureState) {
          context.showError(message: state.message);
        }
      },
      child: SliverPage(
        onRefresh: _getMyGroups,
        controller: _controller,
        title: 'MY_GROUP_TEXT'.tr(),
        titleStyle: Theme.of(context).textTheme.headlineSmall.sectionStyle,
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 22),
            style: mediumButtonStyle,
          ),
          IconButton(
            onPressed: () => context.pushNamed(Routes.createGroup.name),
            icon: const Icon(Icons.add, size: 22),
            style: mediumButtonStyle,
          ),
          const SizedBox(width: 6),
        ],
        slivers: [
          /*  */
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              int id = state.user?.id ?? -1;

              return SliverList.list(
                children: [
                  _groupSection(
                    title: "GROUP_MANAGE_TEXT".tr(),
                    groups:
                        state.groups.where((e) => e.creatorId == id).toList(),
                  ),

                  /*  */
                  const SizedBox(height: 16),
                  _groupSection(
                    title: "GROUP_JOINED_TEXT".tr(),
                    groups:
                        state.groups.where((e) => e.creatorId != id).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _groupSection({
    required String title,
    required List<GroupModel> groups,
  }) {
    return Column(
      children: [
        SectionTitle(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          title: title,
        ),

        /*  */
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: groups.length,
          itemBuilder: (context, index) => GroupCard(group: groups[index]),
        ),
      ],
    );
  }
}
