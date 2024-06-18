import 'dart:io';

class PhotoModel {
  PhotoModel({
    required this.id,
    required this.name,
    required this.file,
  });

  final String id;
  final String name;
  final File file;
}
