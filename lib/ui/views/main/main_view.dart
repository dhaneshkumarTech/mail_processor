import 'package:flutter/material.dart';
import 'package:mail_processor/ui/views/home/home_view.dart';
import 'package:mail_processor/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                label: Text('Home'),
                selectedIcon: Icon(Icons.home),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                label: Text('Settings'),
                selectedIcon: Icon(Icons.settings),
              ),
            ],
            selectedIndex: viewModel.currentIndex,
            onDestinationSelected: viewModel.setIndex,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              onPageChanged: viewModel.setIndex,
              children: const [
                HomeView(),
                SettingsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();
}
