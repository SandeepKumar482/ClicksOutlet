import 'package:clicksoutlet/main.dart';
import 'package:flutter/material.dart';

class ImageDTO extends StatelessWidget {
  final String? imageUrl; // the url of the image to display
  // final double likes; // the number of likes for the image
  // final String username; // the username of the image uploader

  // constructor to initialize the fields
  const ImageDTO({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(imageUrl ?? config.imagePreviewUrl)),
        ],
      ),
    );
  }
}
