import 'dart:io';

class FileModel {
  FileModel({
    required this.id,
    required this.name,
    required this.file,
  });

  final String id;
  final String name;
  final File file;
}
