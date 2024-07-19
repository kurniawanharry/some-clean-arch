import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/register_page.dart';
import 'package:some_app/src/feature/home/presentations/cubit/home_cubit.dart';
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';
import 'package:some_app/src/shared/presentations/pages/map_screen.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  late final HomeCubit _cubit;

  String selectedGender = 'Semua';
  String selectedValue = 'Semua';

  bool isAdmin = true;

  @override
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    _cubit.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary,
                AppColors.main,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        BlocListener<HomeCubit, HomeState>(
          bloc: _cubit,
          listener: (context, state) {
            // if (state is HomeFailed) {
            // context.read<HomeCubit>().refreshToken(isAdmin);
            // getIt<AuthSharedPrefs>().removeToken().then((value) => context.go('/'));
            // }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                );
              } else if (state is HomeUsersSuccess) {
                return _admin(context, state);
              } else {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Data Tidak Ditemukan'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => context.read<HomeCubit>().fetchUsers(),
                            child: const Text('Refresh'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => getIt<AuthSharedPrefs>()
                                .removeToken()
                                .then((value) => context.go('/')),
                            child: const Text('Logout'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  SafeArea _admin(BuildContext context, HomeUsersSuccess state) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Admin',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoggedOut) {
                        context.go('/');
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          backgroundColor: AppColors.main,
                        ),
                        onPressed: () => context.pushNamed('register'),
                        icon: const Icon(Icons.add),
                        label: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text('Users'),
                      );
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Cari User',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                          ),
                        ),
                        onChanged: (value) => _cubit.searchUsers(value),
                      ),
                    ),
                    const TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          text: 'Data Terverif',
                        ),
                        Tab(
                          text: 'Data Belum Terverif',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppDimens.standarBorder),
                                border: Border.all(
                                  color: AppColors.lightGray,
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: selectedGender,
                                isExpanded: true,
                                isDense: true,
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                buttonStyleData: const ButtonStyleData(
                                  height: 40,
                                  elevation: 0,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      overflow: TextOverflow.fade,
                                    ),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedGender = newValue!;
                                  });
                                  context.read<HomeCubit>().filterUsers(
                                        selectedGender.toLowerCase() == 'semua'
                                            ? 'semua'
                                            : selectedGender.toLowerCase() == 'laki-laki'
                                                ? 'male'
                                                : 'female',
                                        disabilityName(selectedValue),
                                      );
                                },
                                items: ['Semua', 'Laki-Laki', 'Perempuan']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value == 'Semua' ? 'Semua Gender' : value),
                                  );
                                }).toList(),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(AppDimens.standarBorder),
                              border: Border.all(
                                color: AppColors.lightGray,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: selectedValue,
                                isExpanded: true,
                                isDense: true,
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                                buttonStyleData: const ButtonStyleData(
                                  height: 40,
                                  elevation: 0,
                                  width: double.maxFinite,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      overflow: TextOverflow.fade,
                                    ),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                  context.read<HomeCubit>().filterUsers(
                                        selectedGender.toLowerCase() == 'semua'
                                            ? 'semua'
                                            : selectedGender.toLowerCase() == 'laki-laki'
                                                ? 'male'
                                                : 'female',
                                        disabilityName(selectedValue),
                                      );
                                },
                                items:
                                    disabilityListV2.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value == 'Semua' ? 'Semua Disabilitas' : value),
                                  );
                                }).toList(),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _users(state, true),
                          _users(state, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _users(HomeUsersSuccess state, bool isVerified) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().fetchUsers(),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemCount: state.users.where((element) => element.isVerified == isVerified).length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          var user =
              state.users.where((element) => element.isVerified == isVerified).toList()[index];

          return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
            return Material(
              child: ListTile(
                title: Text('${user.name}'),
                subtitle: Text('${user.nik}'),
                tileColor: AppColors.white,
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_outlined),
                  onSelected: (String result) async {
                    if (result == 'Verifikasi') {
                      context.read<HomeCubit>().toggleVerification(
                            user.id!,
                            !isVerified,
                          );
                    } else if (result == 'Delete') {
                      context.read<HomeCubit>().deleteUser(
                            user.id!,
                            user,
                          );
                    } else {
                      var result = await context.push(
                        '/register/details/${Uri.decodeComponent(json.encode(user))}&${isAdmin ? '100' : '200'}',
                      ) as UserModel?;

                      if (result != null) {
                        setState(() {
                          context.read<HomeCubit>().updateUser(user.id!, result, isAdmin: isAdmin);
                        });
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Verifikasi',
                      child: ListTile(
                        leading: const Icon(Icons.verified_outlined),
                        title: Text('${isVerified ? 'Batalkan' : ''} Verifikasi'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Hapus'),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  return showModalBottomSheet(
                    // ignore: use_build_context_synchronously
                    context: context,
                    backgroundColor: AppColors.main,
                    isScrollControlled: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: MapScreen(
                                  latitude: double.parse(user.latitude ?? '0.0'),
                                  longitude: double.parse(user.longitude ?? '0.0'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Material(
                                child: ListView(
                                  children: [
                                    ListTile(
                                      title: const Text('NIK'),
                                      subtitle: Text('${user.nik}'),
                                    ),
                                    ListTile(
                                      title: const Text('Name'),
                                      subtitle: Text('${user.name}'),
                                      tileColor: AppColors.lightGray,
                                    ),
                                    ListTile(
                                      title: const Text('Alamat'),
                                      subtitle: Text('${user.address}'),
                                    ),
                                    ListTile(
                                      title: const Text('Tanggal Lahir'),
                                      subtitle: Text(
                                        DateFormat.yMMMMEEEEd('ID').format(
                                          DateFormat('yyyy-MM-dd').parse(user.birthDate!),
                                        ),
                                      ),
                                      tileColor: AppColors.lightGray,
                                    ),
                                    ListTile(
                                      title: const Text('Disabilitas'),
                                      subtitle: Text(
                                        disabilityType(user.disability!),
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Jenis Kelamin'),
                                      subtitle:
                                          Text(user.gender == 'male' ? 'Laki-Laki' : 'Perempuan'),
                                      tileColor: AppColors.lightGray,
                                    ),
                                    ListTile(
                                      title: const Text('Status Verifikasi'),
                                      subtitle: Text(user.isVerified ?? false
                                          ? 'Sudah Terverifikasi'
                                          : 'Belum Terverifikasi'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}
