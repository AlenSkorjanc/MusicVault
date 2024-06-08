import 'package:flutter/material.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/pages/add_song.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:music_vault/pages/main/pdf_viewer_page.dart';


class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final FirebaseService firebaseService = FirebaseService();
  List<Song> songs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    List<Song> fetchedSongs = await firebaseService.fetchSongs();
    setState(() {
      songs = fetchedSongs;
      loading = false;
    });
  }

  void _toggleFavorite(Song song) async {
    await firebaseService.toggleFavorite(song.id, song.favorite);
    _fetchSongs(); // Refresh the list after toggling favorite
  }

  void _openPdf(String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(pdfUrl: pdfUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Songs',
          style: TextStyles.heading2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSong()),
              ).then((value) => _fetchSongs()); // Refresh the list after adding a new song
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(Dimens.spacingXS),
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  Song song = songs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        song.title[0],
                        style: const TextStyle(
                          color: CustomColors.neutralColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(song.title),
                    subtitle: Text('${song.authors} • ${song.genre}'),
                    trailing: IconButton(
                      icon: Icon(
                        song.favorite ? Icons.favorite : Icons.favorite_border,
                        color: song.favorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(song);
                      },
                    ),
                    onTap: () {
                      if (song.pdfUrl != null) {
                        print("SONG PDF " + song.pdfUrl);
                        _openPdf(song.pdfUrl!);
                      } else {
                        // Handle case when PDF URL is not available
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}




//MOVE THIS CLASS AFTER TESTING
// class PdfViewerPage extends StatelessWidget {
//   final String pdfUrl;

//   const PdfViewerPage({required this.pdfUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PDF Viewer"),
//       ),
//       body: SfPdfViewer.network(
//         pdfUrl,
//         // Placeholders for loading and error cases
//         loadingWidget: Center(child: CircularProgressIndicator()),
//         errorWidget: (error) => Center(child: Text("Error loading PDF: $error")),
//       ),
//     );
//   }
// }