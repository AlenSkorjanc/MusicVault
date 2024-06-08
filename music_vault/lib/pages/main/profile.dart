import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text_input.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import 'package:music_vault/utils/snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseService firebaseService = FirebaseService();
  bool validated = false;
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.text = firebaseService.currentUser?.email ?? '';
    usernameController.text = firebaseService.currentUser?.displayName ?? '';

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
      _showToast('Error picking image: $e');
      print('Error picking image: $e');
    }
  }

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  Future<bool?> _submitImage() async {
    if (_image != null) {
      String? imageUrl = await firebaseService.uploadProfilePicture(_image!);

      setState(() {
        _imageUrl = imageUrl;
      });

      if (imageUrl != null) {
        var res = await firebaseService.updateProfilePicture(imageUrl);

        if (res != null && res.isNotEmpty) {
          _showToast(res);
          return false;
        }

        setState(() {
          _image = null;
        });
        return true;
      } else {
        _showToast('Failed to upload image.');
        return false;
      }
    }

    return null;
  }

  void _submitForm() async {
    bool updated = false;
    String? updateMessage;

    // Update email if changed
    if (emailController.text != firebaseService.currentUser?.email) {
      updateMessage = await firebaseService.updateEmail(emailController.text);
      if (updateMessage != null) {
        _showToast(updateMessage);
        return;
      }
      updated = true;
    }

    // Update username if changed
    if (usernameController.text != firebaseService.currentUser?.displayName) {
      updateMessage =
          await firebaseService.updateUsername(usernameController.text);
      if (updateMessage != null) {
        _showToast(updateMessage);
        return;
      }
      updated = true;
    }

    bool? imgRes = await _submitImage();

    if (updated && imgRes == null || imgRes == true) {
      _showToast('Profile updated successfully.');
    } else if (imgRes == null) {
      _showToast('No changes to update.');
    }
  }

  void _logout() async {
    await firebaseService.logoutUser();
    if (mounted) {
      NavigatorHelper.navigateToNextViewReplace(context, const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        title: const Text(
          'Profile',
          style: TextStyles.heading2,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingXS),
          child: Form(
            key: _formKey,
            autovalidateMode: validated
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: Dimens.spacingXS),
                // Username field
                TextInput(
                  labelText: 'Display name',
                  controller: usernameController,
                ),
                const SizedBox(height: Dimens.spacingXS),
                // Email field
                TextInput(
                  labelText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: Dimens.spacingXS),
                // Save button
                Button(
                  text: 'Save',
                  onPressed: () {
                    setState(() {
                      validated = true;
                    });
                    if (_formKey.currentState?.validate() ?? false) {
                      _submitForm();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
