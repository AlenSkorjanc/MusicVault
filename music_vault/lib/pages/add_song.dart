import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/components/button.dart';

class AddSong extends StatefulWidget {
  const AddSong({super.key});

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService firebaseService = FirebaseService();

  String title = '';
  String authors = '';
  String genre = '';
  String pdfUrl = '';
  bool favorite = false;
  String? fileName;

  void _selectPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        fileName = file.name;
        pdfUrl = '';
      });

      if (file.bytes != null) {
        String url = await firebaseService.uploadPdf(file.bytes!, file.name);
        setState(() {
          pdfUrl = url;
        });
      }
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && pdfUrl.isNotEmpty) {
      Song newSong = Song(
        id: '',
        title: title,
        authors: authors,
        genre: genre,
        pdfUrl: pdfUrl,
        favorite: favorite,
      );

      firebaseService.addSong(newSong).then((_) {
        Navigator.pop(context, true); 
      }).catchError((error) {
        print("Error adding song: $error");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Authors'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the authors';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    authors = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the genre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    genre = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Favorite'),
                value: favorite,
                onChanged: (bool value) {
                  setState(() {
                    favorite = value;
                  });
                },
              ),
              const SizedBox(height: Dimens.spacingXS),
              Text(
                fileName ?? 'No file selected',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Button(
                onPressed: _selectPdf,
                text: 'Select PDF File',
              ),
              const SizedBox(height: Dimens.spacingXS),
              Button(
                text: 'Add Song',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
