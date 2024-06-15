import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageDTO extends StatelessWidget {
  final String imageUrl; // the url of the image to display
  // final double likes; // the number of likes for the image
  // final String username; // the username of the image uploader

  // constructor to initialize the fields
  const ImageDTO({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              // Use CachedNetworkImage for efficient image loading
              imageUrl: imageUrl,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                // Starting color of the shimmer
                highlightColor: Colors.grey[100]!,
                // Ending color of the shimmer
                child: Container(
                  color: Colors.grey[300], // Base color for the shimmer effect
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
