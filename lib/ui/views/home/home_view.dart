import 'package:flutter/material.dart';
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
        title: const Text('Mail Processor'),
        actions: [
          TextButton(
            onPressed: viewModel.pickFiles,
            child: Row(
              children: [
                Text(
                  viewModel.files.isEmpty ? 'Import PDFs' : 'PDFs imported',
                ),
                if (viewModel.files.isNotEmpty)
                  const Icon(
                    Icons.check,
                    color: Colors.black,
                  )
              ],
            ),
          ),
          TextButton(
            onPressed: viewModel.pickCsv,
            child: Row(
              children: [
                Text(
                  viewModel.csvData.isEmpty
                      ? 'Import Emails'
                      : 'Emails imported',
                ),
                if (viewModel.csvData.isNotEmpty)
                  const Icon(
                    Icons.check,
                    color: Colors.black,
                  )
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey)),
                ),
                child: ListView.builder(
                  itemCount: viewModel.files.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => viewModel.onUpdate(index),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      color: Colors.grey,
                      child: SfPdfViewer.file(
                        viewModel.files[index],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: viewModel.files.isEmpty
                    ? const Center(
                        child: Text('No files selected'),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Unit Number',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: viewModel.onChangedText,
                                    ),
                                  ),
                                  horizontalSpaceSmall,
                                  viewModel.isBusy
                                      ? const CircularProgressIndicator()
                                      : TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(100, 55),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                          onPressed:
                                              viewModel.unitNumber.isEmpty
                                                  ? null
                                                  : viewModel.processfile,
                                          child: const Text('Send'),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: viewModel.previousDoc,
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                      ),
                                    ),
                                  ),
                                  horizontalSpaceMedium,
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: SfPdfViewer.file(
                                      viewModel.files[viewModel.currentFile],
                                    ),
                                  ),
                                  horizontalSpaceMedium,
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: viewModel.nextDoc,
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
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
      HomeViewModel();
}
