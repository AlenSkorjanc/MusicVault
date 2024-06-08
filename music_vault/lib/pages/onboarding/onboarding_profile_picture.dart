import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/pages/onboarding/onboarding_thank_you.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import 'package:music_vault/utils/snackbar.dart';

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
  Uint8List? _image;
  bool isLoading = false;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDefaultImage();
  }

  Future<void> _loadDefaultImage() async {
    if (firebaseService.currentUser?.photoURL != null &&
        firebaseService.currentUser!.photoURL!.isNotEmpty) {
      setState(() {
        _imageUrl = firebaseService.currentUser!.photoURL;
      });
      return;
    }

    String? url = await firebaseService.getDefaultProfilePicture();
    await firebaseService.updateProfilePicture(url!);
    setState(() {
      _imageUrl = url;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = bytes;
        });
      } else {
        _showToast('No image selected.');
      }
    } catch (e) {
      _showToast('Error picking image.');
      print('Error picking image: $e');
    }
  }

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _submit() async {
    if (_image != null) {
      setState(() {
        isLoading = true;
      });

      String? imageUrl = await firebaseService.uploadProfilePicture(_image!);

      setState(() {
        _imageUrl = imageUrl;
      });

      if (imageUrl != null) {
        var res = await firebaseService.updateProfilePicture(imageUrl);

        if (res != null && res.isNotEmpty) {
          _showToast(res);
          setState(() {
            isLoading = false;
          });
          return;
        }

        if (mounted) {
          NavigatorHelper.navigateToNextView(
            context,
            const OnboardingThankYou(),
          );
        }
      } else {
        _showToast('Failed to upload image.');
      }

      setState(() {
        isLoading = false;
      });
    } else {
      if (mounted) {
        NavigatorHelper.navigateToNextView(
          context,
          const OnboardingThankYou(),
        );
      }
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
                MaterialPageRoute(builder: (context) => const Login()),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : _imageUrl != null
                            ? Image.network(
                                _imageUrl!,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: Dimens.spacingXXS),
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
                  const SizedBox(height: Dimens.spacingM),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Button(
                          text: 'Continue',
                          onPressed: _submit,
                        ),
                  const SizedBox(height: Dimens.spacingXXL2)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
