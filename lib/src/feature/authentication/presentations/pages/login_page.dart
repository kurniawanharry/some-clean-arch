import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/core/util/enum/enum.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  @override
  void dispose() {
    nikController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  UserType userType = UserType.admin;

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
                constraints: const BoxConstraints(maxWidth: 400), // Constrain width for web
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0), // Use fixed padding for web
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Hero(
                                  tag: 'auth-icon',
                                  child: Icon(
                                    MdiIcons.cloverOutline,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Hero(
                              tag: 'auth-hero',
                              child: Text(
                                'Welcome\nHome.',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),

                        // Form fields
                        TextFormField(
                          controller: nikController,
                          keyboardType:
                              userType == UserType.user ? TextInputType.number : TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            hintText: userType == UserType.user ? 'NIK' : 'Username',
                            prefixIcon: Icon(
                              userType == UserType.user
                                  ? MdiIcons.identifier
                                  : MdiIcons.accountOutline,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          inputFormatters: [
                            if (userType == UserType.user) FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Data Kosong';
                            } else if (userType == UserType.user && value!.length < 16) {
                              return 'NIK Harus 16 Angka';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              MdiIcons.lockOutline,
                            ),
                            suffixIcon: MouseRegion(
                              cursor: SystemMouseCursors.click, // Web cursor
                              child: GestureDetector(
                                onTap: () => togglePassword(),
                                child: Icon(
                                  showPassword ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Data Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              // getIt<AuthSharedPrefs>()
                              //     .saveType(state.user.userType ?? 100)
                              //     .then((value) => context.goNamed('home'));
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  behavior: SnackBarBehavior.floating, // Better for web
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              height: 48, // Fixed height for consistency
                              child: ElevatedButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        context.goNamed('home');
                                        // final nik = nikController.text;
                                        // final password = passwordController.text;
                                        // context.read<AuthCubit>().signIn(
                                        //       SignInModel(
                                        //         nik: userType == UserType.user ? nik : null,
                                        //         username: userType == UserType.user ? null : nik,
                                        //         password: password,
                                        //       ),
                                        //     );
                                      },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: state is AuthLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text('Login'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Register link
                        Center(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click, // Web cursor
                            child: TextButton(
                              onPressed: () => context.pushNamed('register'),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Belum mendaftar? ',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.secondary,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: 'Daftar Sekarang',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.third,
                                            decoration: TextDecoration.underline,
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void togglePassword() => setState(() => showPassword = !showPassword);
}
