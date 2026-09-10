import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/github_user_list.dart';
import 'widgets/user_form_dialog.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GithubUsersPage(),
    );
  }
}

class GithubUsersPage extends StatelessWidget {
  const GithubUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GitHub Users'),
      ),
      body: const GithubUserList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add user',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const UserFormDialog(),
        ),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
