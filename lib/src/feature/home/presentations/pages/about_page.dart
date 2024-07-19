import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: Colors.red.shade600,
                  ),
                  onPressed: () => showExitDialog(context),
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
