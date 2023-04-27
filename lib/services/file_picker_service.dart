import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:csv/csv.dart';
import 'package:mail_processor/models/csv_data.dart';
import 'package:path/path.dart' as p;

class FilePickerService {
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

  Future<Directory> createFolderIfNotExists(
    String folderPath,
    String folderName,
  ) async {
    final processedfolderPath = p.join(folderPath, folderName);
    final folder = Directory(processedfolderPath);

    try {
      if (!await folder.exists()) {
        return await folder.create(recursive: true);
      } else {
        return folder;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> moveFileToFolder(
      File file, String folderPath, String folderName) async {
    try {
      final folder = await createFolderIfNotExists(folderPath, folderName);
      final newFilePath = p.join(folder.path, p.basename(file.path));
      await file.rename(newFilePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getFolderPath() async {
    String? directoryPath = await getDirectoryPath(
      confirmButtonText: 'Select Folder',
    );

    if (directoryPath != null) {
      return directoryPath;
    } else {
      return null;
    }
  }
}
