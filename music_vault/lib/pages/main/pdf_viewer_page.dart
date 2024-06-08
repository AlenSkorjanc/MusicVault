import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfControllerPinch _pdfController;
  bool _loading = true;
  String? _errorMessage;
  bool _isScrolling = false;
  double _scrollSpeed = 0.25; // initial scroll speed
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  Future<void> _initializePdfController() async {
    try {
      final pdfData = await _fetchPdf(widget.pdfUrl);
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(pdfData),
      );
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  Future<Uint8List> _fetchPdf(String url) async {
    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to load PDF: ${e.message}');
    }
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(Duration(milliseconds: (1000 ~/ _scrollSpeed).toInt()), (timer) {
      _pdfController.nextPage(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
      );
    });
    setState(() {
      _isScrolling = true;
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    setState(() {
      _isScrolling = false;
    });
  }

  void _increaseSpeed() {
    setState(() {
      _scrollSpeed = (_scrollSpeed + 0.05).clamp(0.05, 1.0); // increase speed, max 1
    });
    if (_isScrolling) {
      _stopAutoScroll();
      _startAutoScroll();
    }
  }

  void _decreaseSpeed() {
    setState(() {
      _scrollSpeed = (_scrollSpeed - 0.05).clamp(0.05, 1.0); // decrease speed, min 0.5
    });
    if (_isScrolling) {
      _stopAutoScroll();
      _startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        //FUTURE FEATURE
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {
        //       // Add your edit PDF functionality here
        //       // For example, you can navigate to a new page where users can edit the PDF
        //     },
        //   ),
        // ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: PdfViewPinch(
                        controller: _pdfController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _isScrolling ? _stopAutoScroll : _startAutoScroll,
                            child: Text(_isScrolling ? 'Stop Scroll' : 'Start Scroll'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: _decreaseSpeed,
                              ),
                              Text('Speed: ${_scrollSpeed.toStringAsFixed(1)}x'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: _increaseSpeed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
