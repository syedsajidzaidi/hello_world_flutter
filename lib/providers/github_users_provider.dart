import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';

class GithubUsersNotifier extends AsyncNotifier<List<GithubUser>> {
  @override
  Future<List<GithubUser>> build() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users'),
      headers: {'Accept': 'application/vnd.github+json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load users (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => GithubUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void add(GithubUser user) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, user]);
  }

  void updateUser(GithubUser updated) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final u in current)
        if (u.id == updated.id) updated else u,
    ]);
  }

  void delete(int id) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((u) => u.id != id).toList());
  }
}

final githubUsersProvider =
    AsyncNotifierProvider<GithubUsersNotifier, List<GithubUser>>(
  GithubUsersNotifier.new,
);

final searchQueryProvider = StateProvider<String>((_) => '');

final filteredUsersProvider = Provider<AsyncValue<List<GithubUser>>>((ref) {
  final usersAsync = ref.watch(githubUsersProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return usersAsync;
  return usersAsync.whenData(
    (users) => users
        .where((u) => u.login.toLowerCase().contains(query))
        .toList(),
  );
});
