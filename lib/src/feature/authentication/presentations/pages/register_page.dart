import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/styles/app_dimens.dart';
import 'package:some_app/src/feature/authentication/data/models/edit_model.dart';
import 'package:some_app/src/feature/authentication/data/models/sign_up_model.dart';
import 'package:some_app/src/feature/authentication/data/models/user_model.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:location/location.dart' as loc;
import 'package:some_app/src/feature/home/presentations/pages/home_page.dart';
import 'package:path/path.dart' as path;

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
  int type = 100;
  LatLng? latLng;
  DateTime selectedDate = DateTime.now();
  final ImagePicker _imagePicker = ImagePicker();

  String selectedValue = 'Disabilitas Netra';

  bool isAdmin = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nikController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dadController = TextEditingController();
  final TextEditingController momController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  bool showPassword = false;
  bool showCPassword = false;

  String imageUrl = '';
  String imageid = '';

  String? currentImageUrl;
  String? currentImageIdUrl;

  @override
  void initState() {
    if (widget.data != null) {
      nikController.text = widget.data?.nik ?? '';
      nameController.text = widget.data?.name ?? '';
      dadController.text = widget.data?.fatherName ?? '';
      momController.text = widget.data?.motherName ?? '';
      gender = widget.data?.gender == 'male' ? 0 : 1;
      selectedValue = disabilityType(widget.data?.disability ?? '');
      addressController.text = widget.data?.address ?? '';
      latLng = LatLng(
        double.parse(widget.data?.latitude ?? ''),
        double.parse(widget.data?.longitude ?? ''),
      );
      if ((widget.data?.photo?.isNotEmpty ?? false) &&
          widget.data?.photo != null &&
          widget.data?.photo != 'file') {
        currentImageUrl = widget.data?.photo ?? '';
      }
      if ((widget.data?.ktp?.isNotEmpty ?? false) &&
          widget.data?.ktp != null &&
          widget.data?.ktp != 'file') {
        currentImageIdUrl = widget.data?.ktp ?? '';
      }

      // Split the date string by '-'
      List<String> dateParts = widget.data?.birthDate?.split('-') ?? [];

// Create a DateTime object from the split parts
      DateTime date = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]));

      dateController.text = DateFormat('dd-MM-yyyy').format(date);

      selectedDate = date;
    }
    type = widget.type ?? 100;
    if (type == 100) {
      isAdmin = true;
    }
    super.initState();
  }

  Future<String> base64ToFile(String base64Str, String fileName) async {
    // Decode the base64 string to bytes
    Uint8List bytes = base64Decode(base64Str);

    // Get the temporary directory of the app
    Directory tempDir = await getTemporaryDirectory();

    // Create a file in the temporary directory with the provided file name
    File file = File('${tempDir.path}/$fileName');

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    // Return the file path
    return file.path;
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
                      widget.data == null ? 'Register User' : 'Edit Profile',
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
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              var file = await _pickImage();
                              if (file != null) {
                                var image = await _compressImage(file);
                                if (image != null) {
                                  setState(() => imageUrl = image.path);
                                }
                              }
                            },
                            child: CircleAvatar(
                              maxRadius: 60,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: imageUrl.isEmpty
                                  ? currentImageUrl != null
                                      ? NetworkImage(currentImageUrl!) as ImageProvider
                                      : FileImage(File(imageUrl))
                                  : FileImage(File(imageUrl)) as ImageProvider,
                              child: imageUrl.isNotEmpty || currentImageUrl != null
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.person_outlined,
                                      color: AppColors.black,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: nikController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            labelText: 'NIK',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade400),
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
                            labelText: 'Nama',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
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
                        // if (widget.data == null) ...[
                        //   const SizedBox(height: 12),
                        //   TextFormField(
                        //     autovalidateMode: AutovalidateMode.onUserInteraction,
                        //     controller: passwordController,
                        //     obscureText: !showPassword,
                        //     decoration: InputDecoration(
                        //       isDense: true,
                        //       contentPadding:
                        //           EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                        //       constraints: const BoxConstraints(minHeight: 40),
                        //       hintText: 'Password',
                        //       prefixIcon: Icon(
                        //         MdiIcons.lockOutline,
                        //       ),
                        //       suffixIcon: GestureDetector(
                        //         onTap: () => togglePassword(),
                        //         child: Icon(
                        //           showPassword ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                        //         ),
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value?.isEmpty ?? false) {
                        //         return 'Password Masih Kosong';
                        //       } else if (value!.length < 6) {
                        //         return 'Password minimal 6 karakter';
                        //       } else if (passwordController.value.text !=
                        //           cPasswordController.value.text) {
                        //         return 'Password tidak sama';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        //   const SizedBox(height: 12),
                        //   TextFormField(
                        //     autovalidateMode: AutovalidateMode.onUserInteraction,
                        //     controller: cPasswordController,
                        //     obscureText: !showCPassword,
                        //     decoration: InputDecoration(
                        //       isDense: true,
                        //       contentPadding:
                        //           EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                        //       constraints: const BoxConstraints(minHeight: 40),
                        //       hintText: 'Confirm Password',
                        //       prefixIcon: Icon(
                        //         MdiIcons.lockOutline,
                        //       ),
                        //       suffixIcon: GestureDetector(
                        //         onTap: () => toggleCPassword(),
                        //         child: Icon(
                        //           showCPassword ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline,
                        //         ),
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value?.isEmpty ?? false) {
                        //         return 'Confirm Password Masih Kosong';
                        //       } else if (value!.length < 6) {
                        //         return 'Password minimal 6 karakter';
                        //       } else if (passwordController.value.text !=
                        //           cPasswordController.value.text) {
                        //         return 'Password tidak sama';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ],
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
                              labelText: 'Tanggal lahir',
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade500),
                              prefixIcon: Icon(
                                MdiIcons.calendarAccountOutline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: dadController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'Nama Ayah',
                            labelText: 'Nama Ayah',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
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
                          controller: momController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: 'Nama Ibu',
                            labelText: 'Nama Ibu',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
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
                            labelText: 'Alamat',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
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
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Foto KTP : '),
                                const SizedBox(height: 5),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                    textStyle: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    var file = await _pickImage();
                                    if (file != null) {
                                      var image = await _compressImage(file);
                                      if (image != null) {
                                        setState(() => imageid = image.path);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.image_outlined, size: 18),
                                  label: Text(imageid.isEmpty || currentImageIdUrl == null
                                      ? 'Pilih KTP'
                                      : 'Ubah KTP'),
                                ),
                              ],
                            ),
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageid.isEmpty
                                      ? currentImageIdUrl != null
                                          ? NetworkImage(currentImageIdUrl ?? '') as ImageProvider
                                          : FileImage(File(imageid))
                                      : FileImage(File(imageid)) as ImageProvider,
                                ),
                              ),
                            ),
                          ],
                        )
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
                            context.pop(true);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User Berhasil Dibuat')),
                            );
                          }

                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
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
                                fatherName: state.model.fatherName,
                                motherName: state.model.motherName,
                                ktp: state.model.ktp,
                                photo: state.model.photo,
                                latitude: state.model.latitude,
                                longitude: state.model.longitude,
                                createdAt: state.model.createdAt,
                                updatedAt: state.model.updatedAt,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User Berhasil di Edit')),
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
                              // final password = passwordController.value.text;

                              String? fixUserImage;
                              String? fixUserImageId;
                              if (imageUrl.isNotEmpty) {
                                File imagefile = File(imageUrl); //convert Path to File
                                Uint8List imagebytes =
                                    await imagefile.readAsBytes(); //convert to bytes
                                fixUserImage = base64.encode(imagebytes);
                              } else {
                                if (currentImageUrl != null) {
                                  fixUserImage = currentImageUrl;
                                } else {
                                  fixUserImage = 'file';
                                }
                              }

                              if (imageid.isNotEmpty) {
                                File imagefile = File(imageid); //convert Path to File
                                Uint8List imagebytes =
                                    await imagefile.readAsBytes(); //convert to bytes
                                fixUserImageId = base64.encode(imagebytes);
                              } else {
                                if (currentImageIdUrl != null) {
                                  fixUserImageId = currentImageIdUrl;
                                } else {
                                  fixUserImageId = 'file';
                                }
                              }

                              if (date.isEmpty) {
                                // ignore: use_build_context_synchronously
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
                                  currentLocation.latitude ?? 0,
                                  currentLocation.longitude ?? 0,
                                );
                              }

                              if (widget.data == null) {
                                var request = SignUpModel(
                                  nik: nik,
                                  name: name,
                                  address: address,
                                  birthDate: formattedDate,
                                  disability: disabilityName(selectedValue),
                                  gender: gender == 0 ? 'male' : 'female',
                                  latitude: '${latLng?.latitude}',
                                  longitude: '${latLng?.longitude}',
                                  fatherName: dadController.value.text,
                                  motherName: momController.value.text,
                                  placeId: '1',
                                  ktp: fixUserImageId,
                                  photo: fixUserImage,
                                  // password: password,
                                );
                                // ignore: use_build_context_synchronously
                                context.read<AuthCubit>().signUp(isAdmin, request);
                              } else {
                                var request = EditModel(
                                  nik: nik,
                                  name: name,
                                  address: address,
                                  birthDate: formattedDate,
                                  disability: disabilityName(selectedValue),
                                  gender: gender == 0 ? 'male' : 'female',
                                  latitude: '${latLng?.latitude}',
                                  longitude: '${latLng?.longitude}',
                                  fatherName: dadController.value.text,
                                  motherName: momController.value.text,
                                  placeId: '1',
                                  ktp: fixUserImageId,
                                  photo: fixUserImage,
                                );
                                // ignore: use_build_context_synchronously
                                context.read<AuthCubit>().editById(
                                      widget.data!.id!,
                                      request,
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

  Future<File?>? _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    } else {
      return File(pickedFile.path);
    }
  }

  Future<File?> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(tempDir.path, 'compressed_${path.basename(file.path)}');

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      format: file.path.endsWith('.png') ? CompressFormat.png : CompressFormat.jpeg,
    );
    if (compressedImage != null) {
      return File(compressedImage.path);
    }
    return null;
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
