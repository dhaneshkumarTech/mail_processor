import 'dart:io';

import 'package:mail_processor/app/app.locator.dart';
import 'package:mail_processor/models/csv_data.dart';
import 'package:mail_processor/services/email_service.dart';
import 'package:mail_processor/services/file_picker_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final filePickerService = locator<FilePickerService>();
  final emailService = locator<EmailService>();
  final _dialogService = locator<DialogService>();

  List<File> files = [];
  List<CsvData> csvData = [];
  int currentFile = 0;

  String unitNumber = '';

  void onChangedText(String value) {
    unitNumber = value;
    notifyListeners();
  }

  void onUpdate(int index) {
    currentFile = index;
    notifyListeners();
  }

  void nextDoc() {
    currentFile = (currentFile + 1) % files.length;
    notifyListeners();
  }

  void previousDoc() {
    currentFile = (currentFile - 1) % files.length;
    notifyListeners();
  }

  void pickFiles() async {
    final resultFiles = await filePickerService.getFiles(true);
    if (resultFiles != null) {
      files = resultFiles;
      notifyListeners();
    }
  }

  void pickCsv() async {
    final file = await filePickerService.getFiles(false);
    if (file != null) {
      try {
        csvData = await filePickerService.readLocalCsv(file.first.path);
        notifyListeners();
      } on Exception catch (e) {
        await _dialogService.showDialog(
          dialogPlatform: DialogPlatform.Material,
          title: 'Error',
          description: e.toString(),
        );
      }
    }
  }

  void processfile() async {
    await moveFile();
    await emailFile();
    removeFile();
  }

  void removeFile() {
    files.removeAt(currentFile);
    if (currentFile == files.length) {
      currentFile = 0;
    }
    notifyListeners();
  }

  Future<void> moveFile() async {
    if (csvData.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please import emails',
        dialogPlatform: DialogPlatform.Material,
      );
      return;
    }
    try {
      await runBusyFuture(
        filePickerService.moveFileToFolder(
          files[currentFile],
          unitNumber,
        ),
      );
    } on Exception catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: e.toString(),
      );
      return;
    }
  }

  Future<void> emailFile() async {
    try {
      await runBusyFuture(emailService.sendEmailWithAttachment(
        files[currentFile],
        csvData.firstWhere((element) => element.unitNumber == unitNumber).email,
      ));
      await _dialogService.showDialog(
        title: 'Success',
        description: 'File moved and email sent successfully',
        dialogPlatform: DialogPlatform.Material,
      );
    } on Exception catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: e.toString(),
        dialogPlatform: DialogPlatform.Material,
      );
      return;
    }
  }
}
