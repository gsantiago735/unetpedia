import 'package:flutter/material.dart';
import 'package:unetpedia/utils/generic_utils.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/widgets/modals/upload_modal.dart';

class UploadFileModal extends StatelessWidget {
  const UploadFileModal({super.key, required this.onGetFile});

  final void Function(FileModel) onGetFile;

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
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: UploadOption(
                  title: "Subir desde Dispositivo",
                  icon: Icons.file_upload_rounded,
                  onPressed: () async {
                    await GenericUtils.getFileFromDevice(
                      onGetFiles: onGetFile,
                    ).then((_) {
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              //const SizedBox(width: 8),
              //Expanded(
              //    child: UploadOption(
              //  title: "Subir desde Galería",
              //  icon: Icons.collections_rounded,
              //  onPressed: () async {
              //    await GenericUtils.getImageFromDevice(
              //      isFromCamera: false,
              //      onGetImage: onGetImage,
              //    ).then((_) {
              //      Navigator.pop(context);
              //    });
              //  },
              //)),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
