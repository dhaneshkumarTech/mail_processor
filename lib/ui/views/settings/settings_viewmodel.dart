import 'package:flutter/material.dart';
import 'package:mail_processor/app/app.locator.dart';
import 'package:mail_processor/main.dart';
import 'package:mail_processor/services/file_picker_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final _filePickerService = locator<FilePickerService>();
  final _snackBarService = locator<SnackbarService>();

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  bool obscureText = true;

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  SettingsViewModel() {
    for (var i = 0; i < controllers.length; i++) {
      controllers[i].text = sp.getString('controller$i') ?? '';
    }
  }

  Future<void> save() async {
    for (var element in controllers) {
      await runBusyFuture(
        sp.setString('controller${controllers.indexOf(element)}', element.text),
      );
    }

    _snackBarService.showSnackbar(
      message: 'Settings saved',
    );
  }

  Future<void> fetchFolderPath() async {
    final result = await runBusyFuture(
      _filePickerService.getFolderPath(),
    );

    if (result != null) {
      controllers[4].text = result;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.dispose();
  }
}
