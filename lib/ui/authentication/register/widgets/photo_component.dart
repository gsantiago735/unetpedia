import 'package:flutter/material.dart';
import 'package:unetpedia/models/generic/photo_model.dart';

class PhotoComponent extends StatelessWidget {
  const PhotoComponent(
      {super.key, this.onPressed, required this.imageSelected});

  final PhotoModel? imageSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDCDAD8),
                border: Border.all(color: const Color(0xFF828282)),
              ),
              child: (imageSelected == null)
                  ? const Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: Color(0xFF828282),
                    )
                  : ClipOval(
                      child: Image.file(imageSelected!.file, fit: BoxFit.cover),
                    ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF282828),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
