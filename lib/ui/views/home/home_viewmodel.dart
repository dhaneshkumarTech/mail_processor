import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mail_processor/app/app.locator.dart';
import 'package:mail_processor/main.dart';
import 'package:mail_processor/models/csv_data.dart';
import 'package:mail_processor/services/email_service.dart';
import 'package:mail_processor/services/file_picker_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final filePickerService = locator<FilePickerService>();
  final emailService = locator<EmailService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController unitNumberController = TextEditingController();
  FocusNode unitNumberFocusNode = FocusNode();

  List<File> files = [];
  List<CsvData> csvData = [];
  int currentFile = 0;

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
          title: 'Error',
          description: e.toString(),
        );
      }
    }
  }

  void processfile() async {
    final unitNumber = unitNumberController.text;

    if (unitNumber.isEmpty) {
      return;
    }

    if (csvData.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please import emails',
      );
      return;
    }
    final folderPath = sp.getString('controller4');
    if (folderPath == null) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please select a folder path in settings view first',
      );
      return;
    }

    final email = sp.getString('controller0');
    if (email!.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please enter an email in settings view first',
      );
      return;
    }

    final password = sp.getString('controller1');

    if (password!.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please enter a password in settings view first',
      );
      return;
    }

    final subject = sp.getString('controller2');
    if (subject!.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please enter a subject in settings view first',
      );
      return;
    }

    final text = sp.getString('controller3');
    if (text!.isEmpty) {
      await _dialogService.showDialog(
        title: 'Error',
        description: 'Please enter a text in settings view first',
      );
      return;
    }

    final recipientEmail = csvData
        .firstWhere(
          (element) => element.unitNumber == unitNumber,
          orElse: () => CsvData(email: '', unitNumber: ''),
        )
        .email;
    await moveFile(folderPath, unitNumber);
    if (recipientEmail.isEmpty) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'No email found for unit number $unitNumber',
      );
    } else {
      await emailFile(recipientEmail, email, password, subject, text);
    }

    unitNumberFocusNode.requestFocus();

    files.removeAt(currentFile);
    notifyListeners();
  }

  Future<void> moveFile(String folderPath, String unitNumber) async {
    try {
      await runBusyFuture(
        filePickerService.moveFileToFolder(
          files[currentFile],
          folderPath,
          unitNumber,
        ),
      );
      _snackbarService.showSnackbar(
        message:
            'The file has been moved successfully. You can find it in $folderPath/$unitNumber',
      );
      unitNumberController.clear();
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Error',
        description: e.toString(),
      );
    }
  }

  Future<void> emailFile(
    String recipientEmail,
    String email,
    String password,
    String subject,
    String text,
  ) async {
    final result = await runBusyFuture(
      emailService.sendEmailWithAttachment(
        files[currentFile],
        email,
        password,
        subject,
        text,
        recipientEmail,
      ),
    );
    if (result) {
      _snackbarService.showSnackbar(
        title: 'Success',
        message:
            'An email has been sent to $recipientEmail with the file attached.',
      );
    } else {
      await _dialogService.showDialog(
        title: 'Error',
        description:
            'An error occurred while sending the email. Please check your credentials.',
      );
    }
  }
}
