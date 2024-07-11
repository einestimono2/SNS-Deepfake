import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/my_children/my_children_bloc.dart';

class ModalSelectChild extends StatefulWidget {
  final Function(ShortUserModel) onSelected;

  const ModalSelectChild({super.key, required this.onSelected});

  @override
  State<ModalSelectChild> createState() => _ModalSelectChildState();
}

class _ModalSelectChildState extends State<ModalSelectChild> {
  @override
  void initState() {
    if (context.read<MyChildrenBloc>().state is! MyChildrenSuccessfulState) {
      getMyChildren();
    }

    super.initState();
  }

  void getMyChildren() {
    context.read<MyChildrenBloc>().add(GetMyChildren());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            const SizedBox(width: 16),
            Text(
              "LIST_CHILDREN_TEXT".tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            IconButton(
              onPressed: getMyChildren,
              icon: const Icon(Icons.update),
            ),
            const SizedBox(width: 16),
          ],
        ),

        /*  */
        const SizedBox(height: 16),
        BlocBuilder<MyChildrenBloc, MyChildrenState>(
          builder: (context, state) {
            if (state is MyChildrenInProgressState ||
                state is MyChildrenInitialState) {
              return SizedBox(
                width: double.infinity,
                height: 0.25.sh,
                child: const Center(child: AppIndicator()),
              );
            } else if (state is MyChildrenSuccessfulState) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.children.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.onSelected(state.children[index]);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    leading: AnimatedImage(
                      url: state.children[index].avatar?.fullPath ?? "",
                      width: 0.125.sw,
                      height: 0.125.sw,
                    ),
                    title: Text(
                      state.children[index].username,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              );
            } else {
              return ErrorCard(
                onRefresh: getMyChildren,
                message: (state as MyChildrenFailureState).message,
              );
            }
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
