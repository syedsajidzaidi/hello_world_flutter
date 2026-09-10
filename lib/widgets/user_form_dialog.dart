import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/github_user.dart';
import '../providers/github_users_provider.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  final GithubUser? user; // null = create, non-null = edit

  const UserFormDialog({super.key, this.user});

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  late final TextEditingController _loginController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController(text: widget.user?.login ?? '');
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(githubUsersProvider.notifier);
    final login = _loginController.text.trim();

    if (widget.user == null) {
      // Use negative timestamp to avoid collisions with real GitHub IDs
      final id = -DateTime.now().millisecondsSinceEpoch;
      notifier.add(GithubUser(
        id: id,
        login: login,
        avatarUrl:
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(login)}&background=random&size=128',
        htmlUrl: 'https://github.com/$login',
      ));
    } else {
      notifier.updateUser(widget.user!.copyWith(login: login));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit User' : 'Add User'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _loginController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Username is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
