import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  const ModToolsScreen({required this.name, super.key});

  final String name;

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/$name/mod-tools/edit-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Column(children: [
        ListTile(
          leading: const Icon(Icons.add_moderator),
          title: const Text('Add Moderators'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Community'),
          onTap: () => navigateToEditCommunityScreen(context),
        ),
      ]),
    );
  }
}
