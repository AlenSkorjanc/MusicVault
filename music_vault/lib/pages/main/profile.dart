import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text_input.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import 'package:music_vault/utils/snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseService firebaseService = FirebaseService();
  bool validated = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    emailController.text = firebaseService.currentUser?.email ?? '';
    usernameController.text = firebaseService.currentUser?.displayName ?? '';
  }

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
          _showToast('Profile picture updated successfully.');
        }
      } else {
        _showToast('Failed to upload image.');
      }
    } else {
      _showToast('Please select an image.');
    }
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
      updateMessage = await firebaseService.updateUsername(usernameController.text);
      if (updateMessage != null) {
        _showToast(updateMessage);
        return;
      }
      updated = true;
    }

    if (updated) {
      _showToast('Profile updated successfully.');
    } else {
      _showToast('No changes to update.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyles.heading2,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: validated
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User profile picture
                GestureDetector(
                  onTap: () async {
                    await _pickImage(ImageSource.gallery);
                    _submit();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? kIsWeb
                            ? NetworkImage(_image!.path) as ImageProvider
                            : FileImage(_image!)
                        : const AssetImage('assets/images/default_avatar.svg'),
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Email field
                TextInput(
                  labelText: 'Display name',
                  controller: usernameController,
                ),
                const SizedBox(height: 16),
                // Email field
                TextInput(
                  labelText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                // Log out button
                Button(
                  text: 'Log Out',
                  onPressed: () async {
                    await firebaseService.logoutUser();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
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
