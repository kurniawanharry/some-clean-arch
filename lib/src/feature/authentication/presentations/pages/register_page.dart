import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_in_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:location/location.dart' as loc;
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';

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
  int gender = 0;
  LatLng? latLng;
  DateTime selectedDate = DateTime.now();

  String selectedValue = 'Disabilitas Netra';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nikController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  bool showPassword = false;
  bool showCPassword = false;

  @override
  void initState() {
    if (widget.data != null) {
      nikController.text = widget.data?.nik ?? '';
      nameController.text = widget.data?.name ?? '';
      nameController.text = widget.data?.name ?? '';
      gender = widget.data?.gender == 'male' ? 0 : 1;
      selectedValue = disabilityType(widget.data?.disability ?? '');
      addressController.text = widget.data?.address ?? '';
      latLng = LatLng(
        double.parse(widget.data?.latitude ?? ''),
        double.parse(widget.data?.longitude ?? ''),
      );

      // Split the date string by '-'
      List<String> dateParts = widget.data?.birthDate?.split('-') ?? [];

// Create a DateTime object from the split parts
      DateTime date =
          DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));

      dateController.text = DateFormat('dd-MM-yyyy').format(date);

      selectedDate = date;
    }
    super.initState();
  }

  @override
  void dispose() {
    nikController.dispose();
    nameController.dispose();
    birthController.dispose();
    dateController.dispose();
    addressController.dispose();
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
                      widget.data == null ? 'Register' : 'Edit Profile',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: nikController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'NIK',
                            prefixIcon: Icon(
                              MdiIcons.identifier,
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            TextInputFormatter.withFunction((oldValue, newValue) =>
                                RegExp(r'^[0-9]*$').hasMatch(newValue.text) ? newValue : oldValue),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'NIK Masih Kosong';
                            } else if (value.length < 16) {
                              return 'Pastikan NIK anda sudah 16 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'Jenis Kelamin',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => toggleGender(0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: gender == 0 ? AppColors.white : AppColors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: gender == 0 ? AppColors.secondary : AppColors.white,
                                  ),
                                  child: Text(
                                    'Laki-Laki',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: gender == 0 ? AppColors.white : AppColors.black,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => toggleGender(1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: gender == 1 ? AppColors.white : AppColors.secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: gender == 1 ? AppColors.secondary : AppColors.white,
                                  ),
                                  child: Text(
                                    'Perempuan',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: gender == 1 ? AppColors.white : AppColors.black,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: birthController,
                        //   decoration: InputDecoration(
                        //     isDense: true,
                        //     contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                        //     constraints: const BoxConstraints(minHeight: 40, maxHeight: 45),
                        //     hintText: 'Tempat lahir',
                        //     prefixIcon: Icon(
                        //       MdiIcons.homeCityOutline,
                        //     ),
                        //   ),
                        //   validator: (value) {
                        //     if (value?.isEmpty ?? false) {
                        //       return 'Data Kosong';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => datePicker(),
                          child: TextFormField(
                            controller: dateController,
                            enabled: false,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                              constraints: const BoxConstraints(minHeight: 40),
                              hintText: 'Tanggal lahir',
                              prefixIcon: Icon(
                                MdiIcons.calendarAccountOutline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'Tipe Disabilitas',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              style: Theme.of(context).textTheme.bodyLarge,
                              underline: const SizedBox(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                              dropdownColor: AppColors.lightGray,
                              items: disabilityList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: addressController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'Alamat',
                          ),
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          maxLines: 4,
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Alamat Masih Kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            textStyle: Theme.of(context).textTheme.labelMedium,
                          ),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var result = await context.pushNamed('map') as Map?;
                            if (result != null) {
                              setState(() {
                                String address = result['address']!!;
                                var lat = result['lat'];
                                var lng = result['lng'];

                                addressController.text = address;
                                latLng = LatLng(lat, lng);
                              });
                            }
                          },
                          icon: const Icon(Icons.location_on_outlined, size: 18),
                          label: const Text('Pilih alamat dari Google Map'),
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
                          if (state is AuthRegistered) {
                            final nik = nikController.text;
                            final password = passwordController.value.text;
                            var request = SignInModel(
                              nik: nik,
                              password: password,
                            );
                            context.read<AuthCubit>().signIn(request);
                          }

                          if (state is AuthSuccess) {
                            // Navigate to the next screen
                            context.goNamed('home', pathParameters: {
                              'type': '200',
                            });
                          }

                          if (state is AuthFailure) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }

                          if (state is AuthEditSucceed) {
                            context.goNamed('home', pathParameters: {'type': '200'});
                          }

                          if (state is AuthEditByIdSucceed) {
                            context.pop(
                              UserModel(
                                id: state.model.id,
                                nik: state.model.nik,
                                name: state.model.name,
                                address: state.model.address,
                                birthDate: state.model.birthDate,
                                disability: state.model.disability,
                                gender: state.model.gender,
                                isVerified: state.model.isVerified,
                                latitude: state.model.latitude.toString(),
                                longitude: state.model.longitude.toString(),
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

                              final nik = nikController.text;
                              final name = nameController.text;
                              final address = addressController.value.text;
                              // final birth = birthController.value.text;
                              final date = dateController.value.text;
                              final password = passwordController.value.text;

                              if (date.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Tanggal Lahir Masih Kosong, Harap Diisi Terlebih Dahulu'),
                                  ),
                                );
                                return;
                              }

                              DateTime temp = DateFormat('dd-MM-yyyy').parse(date);

                              // Format the date to yyyy/MM/dd
                              String formattedDate = DateFormat('yyyy-MM-dd').format(temp);

                              if (latLng == null) {
                                loc.Location location = loc.Location();
                                var currentLocation = await location.getLocation();

                                latLng = LatLng(
                                    currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
                              }

                              if (widget.data == null) {
                                var request = SignUpModel(
                                  nik: nik,
                                  name: name,
                                  address: address,
                                  birthDate: formattedDate,
                                  disability: disabilityName(selectedValue),
                                  gender: gender == 0 ? 'male' : 'female',
                                  latitude: latLng?.latitude,
                                  longitude: latLng?.longitude,
                                  password: password,
                                );
                                // ignore: use_build_context_synchronously
                                context.read<AuthCubit>().signUp(request);
                              } else {
                                var request = EditModel(
                                  nik: nik,
                                  name: name,
                                  address: address,
                                  birthDate: formattedDate,
                                  disability: disabilityName(selectedValue),
                                  gender: gender == 0 ? 'male' : 'female',
                                  latitude: latLng?.latitude,
                                  longitude: latLng?.longitude,
                                );

                                if (widget.type == 100) {
                                  // ignore: use_build_context_synchronously
                                  context.read<AuthCubit>().editById(
                                        widget.data!.id!,
                                        request,
                                      );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  context.read<AuthCubit>().edit(request);
                                }
                              }

                              // context.pushNamed('register');
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

  toggleGender(int value) => setState(() => gender = value);
  togglePassword() => setState(() => showPassword = !showPassword);
  toggleCPassword() => setState(() => showCPassword = !showCPassword);

  datePicker() => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            color: AppColors.white,
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Tanggal',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          foregroundColor: AppColors.third,
                        ),
                        onPressed: () {
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');
                          setState(() {
                            dateController.text = formatter.format(selectedDate);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ).then((value) {
        FocusManager.instance.primaryFocus?.unfocus();
      });
}

String? disabilityName(String name) {
  switch (name) {
    case 'Disabilitas Netra':
      return 'visual';
    case 'Disabilitas Rungu':
      return 'hearing';
    case 'Disabilitas Fisik':
      return 'physical';
    case 'Disabilitas Mental':
      return 'mental';
    case 'Disabilitas Fisik dan Mental':
      return 'physical_and_mental';
    case 'Disabilitas Lainnya':
      return 'other';
  }
  return null;
}

final List<String> disabilityList = [
  'Disabilitas Netra',
  'Disabilitas Rungu',
  'Disabilitas Fisik',
  'Disabilitas Mental',
  'Disabilitas Fisik dan Mental',
  'Disabilitas Lainnya'
];

final List<String> disabilityListV2 = [
  'Semua',
  'Disabilitas Netra',
  'Disabilitas Rungu',
  'Disabilitas Fisik',
  'Disabilitas Mental',
  'Disabilitas Fisik dan Mental',
  'Disabilitas Lainnya'
];
