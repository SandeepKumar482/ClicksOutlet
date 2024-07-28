import 'package:apex_infinity/shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AxNetworkImage extends StatelessWidget {

  final String? imageUrl;
  final double borderRadius;

  final BoxFit boxFit;

  final double? height;
  final double? width;

  final Widget? placeHolderWidget;
  final Widget? errorWidget;

  const AxNetworkImage({
    required this.imageUrl,
    this.borderRadius = 10.0,

    this.boxFit = BoxFit.cover,

    this.height,
    this.width,

    this.placeHolderWidget,
    this.errorWidget
  });

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child:  CachedNetworkImage(
        // Use CachedNetworkImage for efficient image loading
        imageUrl: imageUrl ?? "",
        placeholder: (context, url) {
          return placeHolderWidget ?? AxShimmer(
            child: AxShimmerLoader(
              child: AxShimmerBox(
                height: height ?? 250.0,
                width: width ?? 250.0,
                borderRadius: borderRadius,
              ) ,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return errorWidget ?? SizedBox(
            height: height,
            width: width,
            child: Icon(
              Icons.image_outlined,
              size: (width ?? 250)/2,
            )
          );
        },
        fit: boxFit,
        height: height,
        width: width,
      ),
    );

  }
}
