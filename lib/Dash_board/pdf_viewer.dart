import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path/path.dart' as path;

final storage = FirebaseStorage.instance.ref();

class pdfViewer extends StatefulWidget {
  const pdfViewer({super.key, required this.pdfpath});
  final String pdfpath;

  @override
  State<pdfViewer> createState() => _pdfViewerState();
}

Future<String> _getPdfUrl(String pdfPath) async {
  final Reference reference = FirebaseStorage.instance.ref().child(pdfPath);
  // print("this is url  => ${reference}");
  return await reference.getDownloadURL();
}

class _pdfViewerState extends State<pdfViewer> {
  late Future<File> futureFile;
  @override
  void initState() {
    secureScreen();
    super.initState();
  }
  Future<void> secureScreen() async {
await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE); 
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(path.basenameWithoutExtension(widget.pdfpath)),
          backgroundColor: Colors.redAccent,
        ),
        body: FutureBuilder<String>(
          future: _getPdfUrl(widget.pdfpath),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SfPdfViewer.network(
                snapshot.data!,
                // canShowScrollHead: false,
                pageSpacing: 2,
                // other properties...
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading PDF"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}