import 'package:flutter/material.dart';
import 'package:mail_processor/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:pdfx/pdfx.dart';

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
        title: const Text('Mail Processor'),
        actions: [
          ElevatedButton(
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
          ElevatedButton(
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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: ListView.builder(
                  itemCount: viewModel.controllers.length,
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
                      child: PdfView(
                        builders: PdfViewBuilders<DefaultBuilderOptions>(
                          options: const DefaultBuilderOptions(),
                          documentLoaderBuilder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                          errorBuilder: (_, __) => const Center(
                            child: Text('Error'),
                          ),
                        ),
                        controller: viewModel.controllers[index],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: viewModel.controllers.isEmpty
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
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
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
                            InteractiveViewer(
                              panEnabled: true,
                              minScale: 0.5,
                              maxScale: 2,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: viewModel.previousDoc,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(30),
                                      child: PdfView(
                                        builders: PdfViewBuilders<
                                            DefaultBuilderOptions>(
                                          options:
                                              const DefaultBuilderOptions(),
                                          documentLoaderBuilder: (_) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorBuilder: (_, __) => const Center(
                                            child: Text('Error'),
                                          ),
                                        ),
                                        controller: viewModel
                                            .controllers[viewModel.currentFile],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: viewModel.nextDoc,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.015,
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
