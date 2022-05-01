import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_application/screens/campaign_detail/image_viewer.dart';
import 'package:crowd_application/screens/campaign_detail/pdf_viewer.dart';
import 'package:flutter/material.dart';

class ProofPreview extends StatelessWidget {
  const ProofPreview(
      {Key? key,
      required this.fileName,
      this.fileUrl = "none",
      this.isLocalFile = false})
      : super(key: key);
  final String fileName;
  final String fileUrl;
  final bool isLocalFile;
  @override
  Widget build(BuildContext context) {
    var _isPdf = false;
    if (fileName.endsWith('.pdf')) {
      _isPdf = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          if (_isPdf) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PdfViewer(
                  pdfUrl: fileUrl,
                  isLocal: isLocalFile,
                  fileName: fileName,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageViewer(
                  imageUrl: fileUrl,
                  isLocal: isLocalFile,
                  fileName: fileName,
                ),
              ),
            );
          }
        },
        child: Container(
          height: 90,
          width: 80,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          // color: Colors.amber,
          child: _isPdf
              ? Image.asset('assets/images/pdf.png')
              : isLocalFile
                  ? Image.file(
                      File(fileUrl),
                      fit: BoxFit.cover,
                    ) //we send fileUrl i.e path of File
                  : CachedNetworkImage(
                      imageUrl:
                          "https://fundzer.herokuapp.com/images/funds/$fileName",
                      fit: BoxFit.cover,
                      errorWidget: (context, text, err) => const Center(
                          child: Icon(
                        Icons.error_outline_outlined,
                      )),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
