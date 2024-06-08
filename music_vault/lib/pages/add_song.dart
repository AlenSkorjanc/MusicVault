import 'package:flutter/material.dart';
import 'package:music_vault/services/firebase_service.dart';

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Song newSong = Song(
        id: '',
        title: title,
        authors: authors,
        genre: genre,
        pdfUrl: pdfUrl,
        favorite: favorite,
      );
      firebaseService.addSong(newSong).then((_) {
        Navigator.pop(context, true); // Indicate that a new song was added
      }).catchError((error) {
        // Handle errors if needed
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'PDF URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the PDF URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    pdfUrl = value;
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
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
