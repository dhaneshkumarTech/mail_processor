import 'package:flutter/material.dart';
import 'package:mail_processor/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 32.0,
          left: screenWidth(context) * 0.2,
          right: screenWidth(context) * 0.2,
        ),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: viewModel.controllers[0],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              verticalSpaceMedium,
              TextField(
                controller: viewModel.controllers[1],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffix: IconButton(
                    icon: Icon(
                      viewModel.obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: viewModel.toggleObscureText,
                  ),
                ),
                obscureText: viewModel.obscureText,
              ),
              verticalSpaceMedium,
              TextField(
                controller: viewModel.controllers[2],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Subject',
                  prefixIcon: Icon(Icons.subject),
                ),
              ),
              verticalSpaceMedium,
              TextField(
                controller: viewModel.controllers[3],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Message',
                  prefixIcon: Icon(Icons.message),
                ),
              ),
              verticalSpaceLarge,
              ElevatedButton(
                onPressed: () async {
                  await viewModel.save();
                },
                child: viewModel.isBusy
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}
