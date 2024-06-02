import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';
import '../blocs/blocs.dart';

class EditGroupForm extends StatefulWidget {
  final String groupName;
  final String description;
  final int id;

  const EditGroupForm({
    super.key,
    required this.groupName,
    required this.id,
    required this.description,
  });

  @override
  State<EditGroupForm> createState() => _EditGroupFormState();
}

class _EditGroupFormState extends State<EditGroupForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameFN = FocusNode();
  final _descriptionFN = FocusNode();

  late final TextEditingController _nameCtl;
  late final TextEditingController _descriptionCtl;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {
    _nameCtl = TextEditingController(text: widget.groupName);
    _descriptionCtl = TextEditingController(text: widget.description);

    super.initState();
  }

  @override
  void dispose() {
    _nameFN.dispose();
    _descriptionFN.dispose();
    super.dispose();
  }

  void _handleEdit() {
    if (_loading.value) return;

    if (_nameCtl.text == widget.groupName &&
        _descriptionCtl.text == widget.description) {
      Navigator.of(context).pop();
      return;
    }

    if (_formKey.currentState!.validate() && _nameCtl.text.isNotEmpty) {
      _loading.value = true;
      context.read<GroupActionBloc>().add(UpdateGroupSubmit(
            id: widget.id,
            description: _descriptionCtl.text,
            name: _nameCtl.text,
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () => Navigator.of(context).pop(),
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
                    title: "GROUP_NAME_TEXT".tr(),
                    margin: const EdgeInsets.only(top: 18, bottom: 4),
                  ),
                  TextFormField(
                    onTap: () => _nameFN.requestFocus(),
                    onTapOutside: (_) => _nameFN.unfocus(),
                    controller: _nameCtl,
                    focusNode: _nameFN,
                    textInputAction: TextInputAction.next,
                    validator: AppValidations.validateGroupName,
                    onFieldSubmitted: (_) => _descriptionFN.requestFocus(),
                    decoration: InputDecoration(
                      hintText: "GROUP_NAME_HINT_TEXT".tr(),
                    ),
                  ),
              
                  /*  */
                  SectionTitle(
                    title: "ABOUT_TEXT".tr(),
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                  ),
                  TextFormField(
                    onTap: () => _descriptionFN.requestFocus(),
                    onTapOutside: (_) => _descriptionFN.unfocus(),
                    controller: _descriptionCtl,
                    focusNode: _descriptionFN,
                    minLines: 3,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleEdit(),
                    decoration: InputDecoration(
                      hintText: "GROUP_DESCRIPTION_HINT_TEXT".tr(),
                    ),
                  ),
              
                  /*  */
                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 3),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleEdit,
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
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
