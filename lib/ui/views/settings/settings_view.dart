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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: viewModel.controllers[0],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                verticalSpaceMedium,
                TextField(
                  controller: viewModel.controllers[1],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    contentPadding: EdgeInsets.zero,
                    suffix: GestureDetector(
                      child: Icon(
                        viewModel.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onTap: viewModel.toggleObscureText,
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
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                verticalSpaceMedium,
                TextField(
                  controller: viewModel.controllers[3],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Message',
                    prefixIcon: Icon(Icons.message),
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                verticalSpaceMedium,
                TextField(
                  controller: viewModel.controllers[4],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.folder_open),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: viewModel.fetchFolderPath,
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
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ],
            ),
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
