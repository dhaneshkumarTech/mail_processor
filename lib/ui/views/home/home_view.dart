import 'package:flutter/material.dart';
import 'package:mail_processor/app/app.locator.dart';
import 'package:mail_processor/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.pickFiles();
            },
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                Text(
                  viewModel.files.isEmpty ? ' Import PDFs' : ' PDFs Imported',
                ),
                if (viewModel.files.isNotEmpty)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: viewModel.pickCsv,
            child: Row(
              children: [
                const Icon(Icons.attach_email),
                Text(
                  viewModel.csvData.isEmpty
                      ? ' Import Emails'
                      : ' Emails Imported',
                ),
                if (viewModel.csvData.isNotEmpty)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceSmall,
              if (viewModel.files.isNotEmpty)
                Form(
                  key: viewModel.formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth(context) * 0.25,
                        child: TextFormField(
                          controller: viewModel.unitNumberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Unit Number',
                          ),
                          enabled: viewModel.isBusy ? false : true,
                          focusNode: viewModel.unitNumberFocusNode,
                          onFieldSubmitted: (value) {
                            viewModel.processfile();
                          },
                        ),
                      ),
                      horizontalSpaceSmall,
                      viewModel.isBusy
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              onPressed: () {
                                viewModel.processfile();
                              },
                              child: const Text('Send'),
                            ),
                    ],
                  ),
                ),
              verticalSpaceSmall,
              if (viewModel.files.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: viewModel.previousDoc,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'File ${viewModel.currentFile + 1}/${viewModel.files.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: viewModel.nextDoc,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              if (viewModel.files.isNotEmpty)
                SizedBox(
                  height: screenHeight(context) * 0.8,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.files.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => viewModel.onUpdate(index),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: viewModel.currentFile == index
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: SfPdfViewer.file(
                                    viewModel.files[index],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: screenWidth(context) / 2,
                          height: screenHeight(context) / 2,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SfPdfViewer.file(
                            viewModel.files[viewModel.currentFile],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      locator<HomeViewModel>();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.startFocusRequestTimer();

    super.onViewModelReady(viewModel);
  }

  @override
  bool get disposeViewModel => false;

  @override
  bool get initialiseSpecialViewModelsOnce => true;
}
