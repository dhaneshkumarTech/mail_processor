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
        child: Column(
          children: [
            verticalSpaceSmall,
            Row(
              children: [
                Text(
                  'Total Files: ${viewModel.files.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                SizedBox(
                  width: screenWidth(context) * 0.3,
                  child: TextFormField(
                    controller: viewModel.unitNumberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Unit Number',
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    focusNode: viewModel.unitNumberFocusNode,
                    onFieldSubmitted: (value) async {
                      await viewModel.processfile();
                    },
                  ),
                ),
                horizontalSpaceSmall,
                FilledButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth(context) * 0.1, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  onPressed: viewModel.processfile,
                  label: const Text('Send'),
                ),
                const Spacer(),
                Text(
                  '${viewModel.sendingEmails} Emails In Queue',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(
              thickness: 10,
            ),
            if (viewModel.files.isNotEmpty)
              Container(
                height: screenHeight(context) * 0.7,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.files.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => viewModel.onUpdate(index),
                          child: Container(
                            height: screenHeight(context) * 0.2,
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              right: 10,
                            ),
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: viewModel.currentFile == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            child: Stack(
                              children: [
                                SfPdfViewer.file(
                                  viewModel.files[index],
                                ),
                                Positioned.fill(
                                  child: Container(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.grey,
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
