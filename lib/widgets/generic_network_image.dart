import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GenericNetworkImage extends StatelessWidget {
  const GenericNetworkImage({
    super.key,
    this.url,
    this.borderRadius = 0.0,
  });

  final String? url;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if ((url ?? "").isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) {
            return const Center(child: LoadingIndicator());
          },
          errorWidget: (context, url, error) {
            log(url);
            log(error.toString());
            return const SizedBox.shrink();
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
