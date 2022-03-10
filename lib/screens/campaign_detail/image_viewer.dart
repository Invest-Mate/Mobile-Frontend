import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
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
        child: Image(
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
