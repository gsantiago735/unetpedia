import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/models/generic/photo_model.dart';

class GenericUtils {
  // ========================================================================
  // Media
  // ========================================================================

  // Seleccion de imagen desde camara o galeria del dispositivo
  static Future<void> getImageFromDevice({
    required bool isFromCamera,
    required void Function(PhotoModel) onGetImage,
    List<String> allowedExtensions = const ["jpg", "jpeg", "png"],
  }) async {
    try {
      final source = (isFromCamera) ? ImageSource.camera : ImageSource.gallery;

      // Solicitando permisos
      await Permission.camera.status.then((cameraPermissionStatus) async {
        if (cameraPermissionStatus.isGranted) {
          // Tomando imagen con camara del dispositivo
          await ImagePicker().pickImage(source: source).then((pickedFile) {
            if (pickedFile != null) {
              final extension = pickedFile.path.split('.').last.toLowerCase();

              // Validando extension del archivo
              final allowedExtensionValues =
                  allowedExtensions.map((e) => e.toLowerCase()).toList();

              if (allowedExtensionValues.contains(extension)) {
                final file = File(pickedFile.path);

                final photo = PhotoModel(
                  file: file,
                  name: pickedFile.name,
                  id: DateTime.now().toIso8601String(),
                );

                onGetImage(photo);
              } else {
                log("Ha ocurrido un error con la extension del archivo.");
              }
            } else {
              log("Ningún archivo ha sido seleccionado.");
            }
          });
        } else {
          await Permission.camera.request().then((cameraPermission) {
            if (cameraPermission.isDenied) {
            } else {
              getImageFromDevice(
                  isFromCamera: isFromCamera, onGetImage: onGetImage);
            }
          });
        }
      });
    } catch (e) {
      log("Ha ocurrido un error ${e.toString()}");
    }
  }

  // Seleccion de archivoo desde el dispositivo
  static Future<void> getFileFromDevice({
    required void Function(FileModel) onGetFiles,
    List<String> allowedExtensions = const ["pdf"],
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      var documents = result.files.single.path!;

      final file = FileModel(
        id: DateTime.now().toIso8601String(),
        name: result.names.single ?? "unknown",
        file: File(documents),
      );

      onGetFiles(file);
    }
  }
}
