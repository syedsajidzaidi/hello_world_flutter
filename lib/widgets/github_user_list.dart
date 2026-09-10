import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/github_users_provider.dart';
import 'user_form_dialog.dart';

class GithubUserList extends ConsumerStatefulWidget {
  const GithubUserList({super.key});

  @override
  ConsumerState<GithubUserList> createState() => _GithubUserListState();
}

class _GithubUserListState extends ConsumerState<GithubUserList> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(filteredUsersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) =>
                ref.read(searchQueryProvider.notifier).state = v,
          ),
        ),
        Expanded(
          child: usersAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text('$error', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(githubUsersProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (users) => users.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        title: Text(user.login),
                        subtitle: Text('#${user.id}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Edit',
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => UserFormDialog(user: user),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              tooltip: 'Delete',
                              onPressed: () => ref
                                  .read(githubUsersProvider.notifier)
                                  .delete(user.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
