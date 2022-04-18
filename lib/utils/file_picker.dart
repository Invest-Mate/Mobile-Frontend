import 'dart:io';
import 'package:file_picker/file_picker.dart';

class MyFilePicker {
  Future<File?> showPicker(FileType type) async {
    File? result;
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: false,
    );
    if (pickedFile != null) {
      result = File(pickedFile.files.single.path!);
    }
    return result;
  }

  Future<FilePickerResult?> pickFileForProof() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ["png", "pdf", "jpg", "jpeg"],
    );

    return pickedFile;
  }
}
