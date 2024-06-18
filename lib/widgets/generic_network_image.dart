import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GenericNetworkImage extends StatelessWidget {
  const GenericNetworkImage({
    super.key,
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    if ((url ?? "").isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox();
    }
  }
}
