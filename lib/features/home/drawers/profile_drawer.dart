import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateTouserProfile(String uid, BuildContext context) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toogleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifierProvider);
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(height: 10),
          Text(
            'u/${user.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            title: const Text('My Profile'),
            leading: const Icon(Icons.person),
            onTap: () => navigateTouserProfile(user.uid, context),
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(Icons.logout, color: Pallete.redColor),
            onTap: () => signOut(ref),
          ),
          Switch.adaptive(
            value: theme == Pallete.darkModeAppTheme,
            onChanged: (value) {
              toogleTheme(ref);
            },
          )
        ],
      )),
    );
  }
}
