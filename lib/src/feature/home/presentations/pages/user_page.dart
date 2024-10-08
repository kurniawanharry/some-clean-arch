import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/authentication/data/models/employee_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/pages/register_page.dart';
import 'package:some_app/src/feature/employee/presentations/cubit/employee_cubit.dart';
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
  late final EmployeeCubit _employeeCubit;

  String selectedGender = 'Semua';
  String selectedValue = 'Semua';

  bool isAdmin = true;

  @override
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    _employeeCubit = BlocProvider.of<EmployeeCubit>(context);
    isAdmin = getIt<AuthSharedPrefs>().isAdmin();
    _cubit.fetchUsers(isAdmin);

    if (isAdmin) {
      _employeeCubit.fetchEmpolyee();
    } else {
      _employeeCubit.fetchUser(isAdmin);
    }

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
        if (isAdmin)
          _body(context)
        else
          SafeArea(
              child: Column(
            children: [
              _topBar(context),
              const SizedBox(height: 10),
              Flexible(child: _user(context)),
            ],
          ))
      ],
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _topBar(context),
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.white,
              indicatorColor: AppColors.white,
              dividerColor: AppColors.white,
              unselectedLabelColor: AppColors.white,
              // indicator: ArrowTabBarIndicator(color: AppColors.white),
              tabs: [
                Tab(
                  text: 'User',
                ),
                Tab(
                  text: 'Karyawan',
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _user(context),
                  _employee(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isAdmin)
                Text(
                  'Admin',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                )
              else
                BlocConsumer<EmployeeCubit, EmployeeState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is HomeEmployeeSuccess) {
                      return Text(
                        state.user.name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  if (isAdmin) {
                    context.read<HomeCubit>().fetchUsers(isAdmin);
                    context.read<EmployeeCubit>().fetchEmpolyee();
                  } else {
                    context.read<HomeCubit>().fetchUsers(isAdmin);
                  }
                },
                child: Icon(MdiIcons.refresh, size: 20, color: AppColors.white),
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  backgroundColor: AppColors.main,
                ),
                onPressed: () =>
                    context.push('/register/create/${isAdmin ? '100' : '200'}').then((value) {
                  if (value is bool) {
                    if (value) {
                      _cubit.fetchUsers(isAdmin);
                    }
                  }
                }),
                icon: const Icon(Icons.add),
                label: const Text('User'),
              ),
              if (isAdmin) ...[
                const SizedBox(width: 10),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    backgroundColor: AppColors.main,
                  ),
                  onPressed: () => context.pushNamed('employee').then(
                    (value) {
                      if (value is bool) {
                        if (value) {
                          _employeeCubit.fetchEmpolyee();
                        }
                      }
                    },
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Karyawan'),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _employee(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is HomeEmployeeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Karyawan Berhasil Dihapus',
              ),
            ),
          );
        }
      },
      child: BlocBuilder<EmployeeCubit, EmployeeState>(
        bloc: _employeeCubit,
        builder: (context, state) {
          return Container(
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
                      hintText: 'Cari Karyawan',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                    onChanged: (value) => _employeeCubit.searchUsers(value),
                  ),
                ),
                if (state is HomeEmployeesLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (state is HomeEmployeesFailed)
                  Center(
                    child: Column(
                      children: [
                        const Text('Data Karyawan Tidak Ditemukan'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => context.read<EmployeeCubit>().fetchEmpolyee(),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  )
                else if (state is HomeEmployeesSuccess)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => context.read<EmployeeCubit>().fetchEmpolyee(),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(height: 0),
                        itemCount: state.users.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          var user = state.users[index];

                          return Material(
                            child: ListTile(
                              title: Text('${user.name}'),
                              tileColor: AppColors.white,
                              trailing: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_outlined),
                                onSelected: (String result) async {
                                  if (result == 'Delete') {
                                    context.read<EmployeeCubit>().deleteUser(user.id!, user);
                                  } else {
                                    var result = await context.push(
                                      '/employee/details/${isAdmin ? '100' : '200'}',
                                      extra: user,
                                    ) as EmployeeModel?;

                                    if (result != null) {
                                      setState(() {
                                        context
                                            .read<EmployeeCubit>()
                                            .updateUser(user.id!, result, isAdmin: isAdmin);
                                      });
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                              onTap: null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _user(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is VerifySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.value.isVerified ?? false
                    ? 'User Berhasil Diverifikasi'
                    : 'Verifikasi User Berhasil Dibatalkan',
              ),
            ),
          );
        }

        if (state is HomeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'User Berhasil Dihapus',
              ),
            ),
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        bloc: _cubit,
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
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
                        text: 'Diverifikasi',
                      ),
                      Tab(
                        text: 'Belum Diverifikasi',
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
                              items: disabilityListV2.map<DropdownMenuItem<String>>((String value) {
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
          );
        },
      ),
    );
  }

  Widget _users(HomeState state, bool isVerified) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is HomeFailure) {
      return Center(
        child: Column(
          children: [
            const Text('Data Tidak Ditemukan'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().fetchUsers(isAdmin),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
    if (state is HomeUsersSuccess) {
      return RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().fetchUsers(isAdmin),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemCount: state.users.where((element) => element.isVerified == isVerified).length,
          padding: const EdgeInsets.only(bottom: 100),
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
                          '/register/details/${isAdmin ? '100' : '200'}',
                          extra: user,
                        ) as UserModel?;

                        if (result != null) {
                          setState(() {
                            context.read<HomeCubit>().updateUser(user.id!, result);
                          });
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      if (isAdmin)
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
                      if (isAdmin)
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
                    final Uint8List markerIcon = await createCustomMarkerBitmap(
                      'NIK: ${user.nik}\nNama: ${user.name}\nDisabilitas: ${user.disability}\n',
                      // "assets/images/clover_tree.png",
                      user.photo ?? '',
                      user.isVerified ?? false,
                    );
                    var marker = Marker(
                      markerId: MarkerId('${user.nik}'),
                      position: LatLng(
                          double.parse(user.latitude ?? '0'), double.parse(user.longitude ?? '0')),
                      infoWindow: InfoWindow(title: '${user.address}'),
                      draggable: false,
                      // ignore: deprecated_member_use
                      icon: BitmapDescriptor.fromBytes(markerIcon),
                    );

                    String? urlPhoto;
                    if ((user.photo?.isEmpty ?? true) || user.photo == 'file') {
                    } else {
                      urlPhoto = user.photo ?? '';
                    }

                    String? urlId;
                    if ((user.ktp?.isEmpty ?? true) || user.ktp == 'file') {
                    } else {
                      urlId = user.ktp ?? '';
                    }
                    return await showModalBottomSheet(
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
                                    markers: marker,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: ListView(
                                    children: [
                                      const SizedBox(height: 5),
                                      ListTile(
                                        title: const Text('Foto Profile'),
                                        trailing: urlPhoto != null
                                            ? Image.network(urlPhoto)
                                            : const Text('Gambar Belum Ada'),
                                      ),
                                      const SizedBox(height: 5),
                                      ListTile(
                                        title: const Text('KTP'),
                                        trailing: urlId != null
                                            ? Image.network(urlId)
                                            : const Text('Gambar Belum Ada'),
                                        tileColor: AppColors.lightGray,
                                      ),
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
                                          DateFormat.yMMMMEEEEd('id_ID').format(
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
                                            ? 'Sudah Diverifikasi'
                                            : 'Belum Diverifikasi'),
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
    return const SizedBox();
  }
}
