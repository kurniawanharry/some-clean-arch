import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key, this.data, this.type});

  final EmployeeModel? data;
  final int? type;

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  bool showPassword = false;
  bool showCPassword = false;

  bool isAdmin = false;

  @override
  void initState() {
    if (widget.data != null) {
      nameController.text = widget.data?.name ?? '';
      usernameController.text = widget.data?.username ?? '';
    }
    if (widget.type == 100) {
      isAdmin = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    super.dispose();
  }

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
                      widget.data == null ? 'Register Karyawan' : 'Edit Karyawan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimens.paddingStandar,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: nameController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'Nama',
                            prefixIcon: Icon(
                              MdiIcons.accountOutline,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Nama Masih Kosong';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: usernameController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'Username',
                            prefixIcon: Icon(
                              MdiIcons.accountOutline,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Username Masih Kosong';
                            }

                            return null;
                          },
                        ),
                        if (widget.data == null) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                              constraints: const BoxConstraints(minHeight: 40),
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
                                return 'Password Masih Kosong';
                              } else if (value!.length < 6) {
                                return 'Password minimal 6 karakter';
                              } else if (passwordController.value.text !=
                                  cPasswordController.value.text) {
                                return 'Password tidak sama';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: cPasswordController,
                            obscureText: !showCPassword,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                              constraints: const BoxConstraints(minHeight: 40),
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(
                                MdiIcons.lockOutline,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () => toggleCPassword(),
                                child: Icon(
                                  showCPassword ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return 'Confirm Password Masih Kosong';
                              } else if (value!.length < 6) {
                                return 'Password minimal 6 karakter';
                              } else if (passwordController.value.text !=
                                  cPasswordController.value.text) {
                                return 'Password tidak sama';
                              }
                              return null;
                            },
                          ),
                        ],
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
                          if (state is AuthEmployeCreated) {
                            context.goNamed('home');
                          }
                          if (state is AuthEmployeEdited) {
                            context.pop(
                              EmployeeModel(
                                id: state.model.id,
                                name: state.model.name,
                                username: state.model.username,
                                createdAt: state.model.createdAt,
                                updatedAt: state.model.updatedAt,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final name = nameController.text;
                              final password = passwordController.value.text;
                              final username = usernameController.value.text;

                              if (widget.data == null) {
                                context.read<AuthCubit>().createEmplyoee(
                                      EmployeeModel(
                                          name: name, username: username, password: password),
                                    );
                              } else {
                                context.read<AuthCubit>().editEmplyoee(
                                      widget.data?.id ?? 0,
                                      EmployeeModel(
                                        name: name,
                                        username: username,
                                      ),
                                    );
                              }
                            },
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.main,
                                    ),
                                  )
                                : Text(widget.data == null ? 'Register' : 'Edit'),
                          );
                        },
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
  toggleCPassword() => setState(() => showCPassword = !showCPassword);
}
