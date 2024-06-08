import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/pages/authentication/sign_up.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import 'package:music_vault/utils/snackbar.dart';
import 'dart:io';

class OnboardingProfilePicture extends StatefulWidget {
  const OnboardingProfilePicture({super.key});

  @override
  State<OnboardingProfilePicture> createState() =>
      _OnboardingProfilePictureState();
}

class _OnboardingProfilePictureState extends State<OnboardingProfilePicture> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validated = false;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        _showToast('No image selected.');
      }
    } catch (e) {
      _showToast('Error picking image: $e');
      print('Error picking image: $e');
    }
  }

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _submit() async {
    if (_image != null) {
      String? imageUrl = await firebaseService.uploadProfilePicture(_image!);

      if (imageUrl != null) {
        var res = await firebaseService.updateProfilePicture(imageUrl);

        if (res != null && res.isNotEmpty) {
          _showToast(res);
          return;
        }

        if (mounted) {
          NavigatorHelper.navigateToNextView(
            context,
            const SignUp(),
          );
        }
      } else {
        _showToast('Failed to upload image.');
      }
    } else {
      _showToast('Please select an image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await firebaseService.logoutUser();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignUp()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Form(
              key: _formKey,
              autovalidateMode: validated
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Set Profile Picture',
                    style: TextStyles.heading1,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: kIsWeb
                              ? Image.network(
                                  _image!.path,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _image!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: SvgPicture.asset(
                            'assets/images/default_avatar.svg',
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(height: Dimens.spacingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Continue',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  LinkText(
                    text: 'Skip for now',
                    onPressed: () {
                      NavigatorHelper.navigateToNextView(
                        context,
                        const SignUp(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
