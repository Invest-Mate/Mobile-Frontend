import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.imageUrl, this.isLocal = false})
      : super(key: key);
  final String imageUrl;
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
            : Image(
                image: NetworkImage(imageUrl),
              ),
      ),
    );
  }
}
