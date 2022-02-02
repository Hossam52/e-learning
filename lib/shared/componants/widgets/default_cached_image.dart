import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultCachedNetworkImage extends StatelessWidget {
  DefaultCachedNetworkImage({Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      placeholder: (context, url) => Shimmer.fromColors(
        highlightColor: (Colors.grey[200])!,
        baseColor: (Colors.grey[300])!,
        child: Container(
          width: double.infinity,
          height: height,
          color: Colors.grey[300],
        ),
      ),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
