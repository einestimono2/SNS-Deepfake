import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

class RenameConversationForm extends StatefulWidget {
  final int id;
  final String oldName;

  const RenameConversationForm({
    super.key,
    required this.id,
    required this.oldName,
  });

  @override
  State<RenameConversationForm> createState() => _RenameConversationFormState();
}

class _RenameConversationFormState extends State<RenameConversationForm> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  final _nameFN = FocusNode();
  late final TextEditingController _nameCtl;

  @override
  void initState() {
    _nameCtl = TextEditingController(text: widget.oldName);
    super.initState();
  }

  @override
  void dispose() {
    _nameFN.dispose();
    super.dispose();
  }

  void _handleRename() {
    if (_loading.value) return;

    if (_nameCtl.text.isNotEmpty && _nameCtl.text == widget.oldName) {
      Navigator.of(context).pop();
      return;
    }

    if (_formKey.currentState!.validate() && _nameCtl.text.isNotEmpty) {
      _loading.value = true;

      context.read<ConversationDetailsBloc>().add(RenameConversationSubmit(
            id: widget.id,
            name: _nameCtl.text,
            onSuccess: (data) => Navigator.of(context).pop(data),
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SectionTitle(
                    title: "CONVERSATION_NAME_TEXT".tr(),
                    margin: const EdgeInsets.only(top: 18, bottom: 4),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    onTap: () => _nameFN.requestFocus(),
                    onTapOutside: (_) => _nameFN.unfocus(),
                    controller: _nameCtl,
                    focusNode: _nameFN,
                    textInputAction: TextInputAction.done,
                    validator: AppValidations.validateGroupName,
                    onFieldSubmitted: (_) => _handleRename(),
                    decoration: InputDecoration(
                      hintText: "GROUP_NAME_HINT_TEXT".tr(),
                    ),
                  ),

                  /*  */
                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 3),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleRename,
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _loading,
                        builder: (context, value, child) => value
                            ? const AppIndicator(size: 18)
                            : Text(
                                "UPDATE_TEXT".tr(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.redAccent.shade200,
                padding: const EdgeInsets.all(6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.clear, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
