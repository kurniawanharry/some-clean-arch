import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    this.data,
    this.type,
  });

  final UserModel? data;
  final int? type;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: context.pop,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                          ),
                        ),
                        Hero(
                          tag: 'auth-icon',
                          child: Icon(
                            MdiIcons.cloverOutline,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Hero(
                          tag: 'auth-hero',
                          child: Text(
                            widget.data == null ? 'Register User' : 'Edit Profile',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
