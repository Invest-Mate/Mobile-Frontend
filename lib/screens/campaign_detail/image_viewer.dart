import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key? key,
    required this.imageUrl,
    this.isLocal = false,
    this.fileName = "None",
  }) : super(key: key);
  final String imageUrl;
  final String fileName;

  final bool isLocal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      bottomSheet: Container(
        height: 50,
        color: Colors.black,
      ),
      body: Center(
        child: isLocal
            ? Image.file(File(imageUrl))
            : CachedNetworkImage(
                imageUrl: fileName,
              ),
      ),
    );
  }
}
