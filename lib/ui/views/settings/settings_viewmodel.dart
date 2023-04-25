import 'package:flutter/material.dart';
import 'package:mail_processor/main.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  List<TextEditingController> controllers = [
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
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.dispose();
  }
}
