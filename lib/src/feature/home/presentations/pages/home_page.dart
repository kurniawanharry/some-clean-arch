import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

Future showExitDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Apakah kamu yakin ingin keluar?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () async {
            await getIt<AuthSharedPrefs>().removeToken();
            // ignore: use_build_context_synchronously
            context.go('/');
          },
          child: const Text('Iya'),
        ),
      ],
    ),
  );
}
