import 'package:crowd_application/screens/campaign_detail/image_viewer.dart';
import 'package:crowd_application/screens/campaign_detail/pdf_viewer.dart';
import 'package:flutter/material.dart';

class ProofPreview extends StatelessWidget {
  const ProofPreview({Key? key, required this.fileName, required this.fileUrl})
      : super(key: key);
  final String fileName;
  final String fileUrl;
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
                builder: (context) => PdfViewer(pdfUrl: fileUrl),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageViewer(imageUrl: fileUrl),
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
              : Image.network(
                  fileUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
