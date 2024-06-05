import 'package:flutter/material.dart';
import 'package:unetpedia/utils/generic_utils.dart';
import 'package:unetpedia/models/generic/photo_model.dart';

class UploadModal extends StatelessWidget {
  const UploadModal({super.key, required this.onGetImage});

  final void Function(PhotoModel) onGetImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _UploadOption(
                  title: "Tomar una Foto",
                  icon: Icons.camera_alt_rounded,
                  onPressed: () async {
                    await GenericUtils.getImageFromDevice(
                      isFromCamera: true,
                      onGetImage: onGetImage,
                    ).then((_) {
                      Navigator.pop(context);
                    });
                  },
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: _UploadOption(
                  title: "Subir desde Galería",
                  icon: Icons.collections_rounded,
                  onPressed: () async {
                    await GenericUtils.getImageFromDevice(
                      isFromCamera: false,
                      onGetImage: onGetImage,
                    ).then((_) {
                      Navigator.pop(context);
                    });
                  },
                )),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ));
  }
}

class _UploadOption extends StatelessWidget {
  const _UploadOption(
      {required this.title, required this.icon, required this.onPressed});

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
