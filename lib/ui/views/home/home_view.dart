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
                  viewModel.files.isEmpty ? 'Attach PDFs' : 'PDFs Attached',
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
                      ? 'Attach Emails'
                      : 'Emails Attached',
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
        child: Center(
          child: Row(
            children: [
              Container(
                width: 250,
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
                      width: 200,
                      height: 200,
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
                width: MediaQuery.of(context).size.width - 250,
                child: viewModel.controllers.isEmpty
                    ? const Center(
                        child: Text('No files selected'),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Unit Number',
                                    ),
                                    onChanged: viewModel.onChangedText,
                                  ),
                                ),
                                horizontalSpaceSmall,
                                viewModel.isBusy
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: viewModel.unitNumber.isEmpty
                                            ? null
                                            : viewModel.moveFile,
                                        child: const Text('Send'),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 500,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: viewModel.previousPage,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 48,
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: 500,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(30),
                                  child: PdfView(
                                    builders:
                                        PdfViewBuilders<DefaultBuilderOptions>(
                                      options: const DefaultBuilderOptions(),
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
                                  onPressed: viewModel.nextPage,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 48,
                                  ),
                                ),
                              ],
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
      HomeViewModel();
}
