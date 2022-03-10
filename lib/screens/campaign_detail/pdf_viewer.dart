import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  const PdfViewer({Key? key, required this.pdfUrl}) : super(key: key);
  final String pdfUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 244, 244),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SfPdfViewer.network(pdfUrl),
      ),
    );
  }
}
