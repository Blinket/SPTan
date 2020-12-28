import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilesPicker {
  Future<File> pickImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null)
      return File(result.files.single.path);
    else
      return null;
  }

  Future<File> pickPdf() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null)
      return File(result.files.single.path);
    else
      return null;
  }
}
