import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  const PdfViewer({
    Key? key,
    required this.pdfUrl,
    this.isLocal = false,
    this.fileName = "None",
  }) : super(key: key);
  final String pdfUrl;
  final String fileName;
  final bool isLocal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 244, 244),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: isLocal
            ? SfPdfViewer.file(File(pdfUrl))
            : SfPdfViewer.network(
                "https://fundzer.herokuapp.com/images/funds/$fileName",
              ),
      ),
    );
  }
}
