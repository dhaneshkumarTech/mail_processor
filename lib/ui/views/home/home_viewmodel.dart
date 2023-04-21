import 'dart:io';

import 'package:mail_processor/app/app.locator.dart';
import 'package:mail_processor/models/csv_data.dart';
import 'package:mail_processor/services/email_service.dart';
import 'package:mail_processor/services/file_picker_service.dart';
import 'package:pdfx/pdfx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final filePickerService = locator<FilePickerService>();
  final emailService = locator<EmailService>();
  final _dialogService = locator<DialogService>();

  List<File> files = [];
  List<PdfController> controllers = [];
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

  void nextPage() {
    currentFile = (currentFile + 1) % controllers.length;
    notifyListeners();
  }

  void previousPage() {
    currentFile = (currentFile - 1) % controllers.length;
    notifyListeners();
  }

  void pickFiles() async {
    controllers.clear();
    notifyListeners();
    final files = await filePickerService.getFiles(true);
    if (files != null) {
      this.files = files;
      final List<PdfController> newControllers = files
          .map((e) => PdfController(
                document: PdfDocument.openFile(e.path),
              ))
          .toList();
      controllers = newControllers;
      onUpdate(0);
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
          title: 'Error',
          description: e.toString(),
        );
      }
    }
  }

  void processfile() async {
    await moveFile();
    await send();
  }

  void removeFile() {
    files.removeAt(currentFile);
    controllers.removeAt(currentFile);
    if (currentFile == files.length) {
      currentFile = 0;
    }
    notifyListeners();

    if (files.isEmpty) {
      controllers.clear();
      notifyListeners();
    }
  }

  Future<void> moveFile() async {
    try {
      if (csvData.isEmpty) {
        await _dialogService.showDialog(
          title: 'Error',
          description: 'Please attach emails',
        );
        return;
      }

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
    }
  }

  Future<void> send() async {
    try {
      await runBusyFuture(emailService.sendEmailWithAttachment(
        files[currentFile],
        csvData.firstWhere((element) => element.unitNumber == unitNumber).email,
      ));
      await _dialogService.showDialog(
        title: 'Success',
        description: 'File moved and email sent successfully',
      );
    } on Exception catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: e.toString(),
      );
    }
  }
}
