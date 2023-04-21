import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:mail_processor/models/csv_data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerService {

  Future<bool> requestPermission() async {
    try {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  Future<List<File>?> getFiles(bool multiple) async {
    try {
      final files = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: multiple ? ['pdf'] : ['csv'],
        allowMultiple: multiple,
      );

      if (files != null) {
        return files.files.map((e) => File(e.path!)).toList();
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<List<CsvData>> readLocalCsv(String filePath) async {
    try {
      File f = File(filePath);
      final input = f.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      // convert fields to CsvData
      fields.removeAt(0);
      List<CsvData> tempFields = [];
      for (var field in fields) {
        CsvData csvData = CsvData(
          unitNumber: field[0].toString(),
          email: field[1],
        );
        tempFields.add(csvData);
      }

      return tempFields;
    } catch (e) {
      throw Exception('Error reading local CSV file: $e');
    }
  }

  Future<Directory> createFolderIfNotExists(String folderName) async {
    final appDir = await getDownloadsDirectory();
    final folderPath = p.join(appDir!.path, folderName);
    final folder = Directory(folderPath);

    if (!await folder.exists()) {
      return await folder.create(recursive: true);
    } else {
      return folder;
    }
  }

  Future<void> moveFileToFolder(File file, String folderName) async {
    final folder = await createFolderIfNotExists(folderName);
    final newFilePath = p.join(folder.path, p.basename(file.path));
    await file.rename(newFilePath);
  }
}
