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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimens.paddingStandar,
                  child: Form(
                    key: _formKey,
                    child: Column(
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
                            // SegmentedButton<UserType>(
                            //   segments: [
                            //     ButtonSegment<UserType>(
                            //       value: UserType.user,
                            //       icon: Icon(MdiIcons.accountOutline),
                            //     ),
                            //     ButtonSegment<UserType>(
                            //       value: UserType.admin,
                            //       icon: Icon(MdiIcons.accountLockOutline),
                            //     ),
                            //   ],
                            //   selected: <UserType>{userType},
                            //   onSelectionChanged: (p0) => setState(() {
                            //     nikController.clear();
                            //     userType = p0.first;
                            //   }),
                            // )
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
                        TextFormField(
                          controller: nikController,
                          keyboardType:
                              userType == UserType.user ? TextInputType.number : TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            hintText: userType == UserType.user ? 'NIK' : 'Username',
                            prefixIcon: Icon(
                              userType == UserType.user
                                  ? MdiIcons.identifier
                                  : MdiIcons.accountOutline,
                            ),
                          ),
                          inputFormatters: [
                            if (userType == UserType.user) FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Data Kosong';
                            } else if (userType == UserType.user && value!.length < 16) {
                              return 'NIK Harus 16 Angka';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              MdiIcons.lockOutline,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => togglePassword(),
                              child: Icon(
                                showPassword ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Data Kosong';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: AppDimens.paddingStandar,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            getIt<AuthSharedPrefs>()
                                .saveType(state.user.userType ?? 100)
                                .then((value) => context.goNamed('home'));
                          } else if (state is AuthFailure) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              final nik = nikController.text;
                              final password = passwordController.text;
                              context.read<AuthCubit>().signIn(
                                    SignInModel(
                                      nik: userType == UserType.user ? nik : null,
                                      username: userType == UserType.user ? null : nik,
                                      password: password,
                                    ),
                                  );
                            },
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.main,
                                    ),
                                  )
                                : const Text('Login'),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.center,
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
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  togglePassword() => setState(() => showPassword = !showPassword);
}
