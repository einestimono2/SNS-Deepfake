import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';
import '../../../app/app.dart';
import '../blocs/bloc.dart';
import '../widgets/conversation_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late final int id;
  final int _currentPage = 1;

  @override
  void initState() {
    id = context.read<AppBloc>().state.user!.id!;
    _getMyConversations();
    super.initState();
  }

  Future<void> _getMyConversations() async {
    context.read<MyConversationsBloc>().add(
          GetMyConversations(
            page: _currentPage,
            size: AppStrings.conversationPageSize,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      onRefresh: _getMyConversations,
      title: "CHAT_PAGE_TITLE_TEXT".tr(),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _getMyConversations,
          icon: const Icon(FontAwesomeIcons.solidPenToSquare, size: 18),
        ),
      ],
      slivers: [
        /* List Post Section */
        SliverToBoxAdapter(
          child: Scrollbar(
            child: BlocBuilder<MyConversationsBloc, MyConversationsState>(
              builder: (context, state) {
                if (state is InProgressState || state is InitialState) {
                  return const ShimmerConversationCard();
                } else if (state is SuccessfulState) {
                  return state.conversations.isEmpty
                      ? const Text("No data")
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 3.h),
                          itemCount: state.conversations.length,
                          itemBuilder: (_, i) => ConversationCard(
                            conversation: state.conversations[i],
                            myId: id,
                          ),
                        );
                } else if (state is FailureState) {
                  return Text(state.message);
                } else {
                  return const Text("Something went wrong");
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
