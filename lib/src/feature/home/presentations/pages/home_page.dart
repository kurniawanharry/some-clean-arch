import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/core/util/constants/constants.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/register_page.dart';
import 'package:some_app/src/feature/home/presentations/cubit/home_cubit.dart';
import 'package:some_app/src/feature/map/presentations/pages/google_map_page.dart';
import 'package:some_app/src/shared/presentations/pages/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.type = 200,
  });

  final int? type;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _cubit;

  bool isAdmin = false;

  String selectedGender = 'Semua';
  String selectedValue = 'Semua';

  @override
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    if (widget.type == 200) {
      _cubit.fetchUser(); //
    } else {
      isAdmin = true;
      _cubit.fetchUsers();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              if (state is HomeFailed) {
                getIt<AuthSharedPrefs>().removeToken().then((value) => context.go('/'));
              }
            },
            child: BlocBuilder<HomeCubit, HomeState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (state is HomeUserSuccess) {
                    var user = state.user;
                    return _user(user);
                  } else if (state is HomeUsersSuccess) {
                    return _admin(context, state);
                  } else {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
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
                      return TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.white,
                          backgroundColor: Colors.red.shade600,
                        ),
                        onPressed: () => showExitDialog(context),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text('Log Out'),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppDimens.standarBorder),
                                border: Border.all(
                                  color: AppColors.lightGray,
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedGender,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 24,
                                isExpanded: true,
                                isDense: true,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      overflow: TextOverflow.fade,
                                    ),
                                underline: const SizedBox(),
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
                                dropdownColor: AppColors.lightGray,
                                items: ['Semua', 'Laki-Laki', 'Perempuan']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value == 'Semua' ? 'Semua Gender' : value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 10),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppDimens.standarBorder),
                                border: Border.all(
                                  color: AppColors.lightGray,
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedValue,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 24,
                                isExpanded: true,
                                isDense: true,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                underline: const SizedBox(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                  context.read<HomeCubit>().filterUsers(
                                        selectedGender.toLowerCase() == 'Semua'
                                            ? 'semua'
                                            : selectedGender.toLowerCase() == 'laki-laki'
                                                ? 'male'
                                                : 'female',
                                        disabilityName(selectedValue),
                                      );
                                },
                                dropdownColor: AppColors.lightGray,
                                items:
                                    disabilityListV2.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value == 'Semua' ? 'Semua Disabilitas' : value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
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
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: state.users.where((element) => element.isVerified == isVerified).length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var user = state.users.where((element) => element.isVerified == isVerified).toList()[index];

        return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          if (state is UserLoading) {
            return const CircularProgressIndicator();
          }
          return Material(
            child: ListTile(
              title: Text('${user.name}'),
              subtitle: Text('${user.nik}'),
              tileColor: AppColors.white,
              trailing: Switch.adaptive(
                activeTrackColor: AppColors.secondary,
                value: user.isVerified ?? false,
                onChanged: (value) => context.read<HomeCubit>().toggleVerification(
                      user.id!,
                      value,
                    ),
              ),
              onTap: () async {
                var data = await rootBundle.load('${imagePath}logo.png');
                var image = data.buffer.asUint8List();
                BitmapDescriptor userPicture = await getMarkerIcon(
                  image,
                  const Size(150.0, 150.0),
                );
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
                                bitMap: userPicture,
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
    );
  }

  Center _user(UserModel user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: Column(
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
                  subtitle: Text(disabilityType(user.disability!)),
                ),
                ListTile(
                  title: const Text('Jenis Kelamin'),
                  subtitle: Text(user.gender == 'male' ? 'Laki-Laki' : 'Perempuan'),
                  tileColor: AppColors.lightGray,
                ),
                ListTile(
                  title: const Text('Status Verifikasi'),
                  subtitle: Text(
                      user.isVerified ?? false ? 'Sudah Terverifikasi' : 'Belum Terverifikasi'),
                ),
              ],
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.push(
                      '/register/details/${Uri.decodeComponent(json.encode(user))}',
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Edit'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => showExitDialog(context),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Log Out'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> showExitDialog(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

String disabilityType(String name) {
  switch (name) {
    case 'visual':
      return 'Disabilitas Netra';
    case 'hearing':
      return 'Disabilitas Rungu';
    case 'physical':
      return 'Disabilitas Fisik';
    case 'mental':
      return 'Disabilitas Mental';
    case 'physical_and_mental':
      return 'Disabilitas Fisik dan Mental';
    case 'other':
      return 'Disabilitas Lainnya';
    default:
      return 'Disabilitas Netra';
  }
}
