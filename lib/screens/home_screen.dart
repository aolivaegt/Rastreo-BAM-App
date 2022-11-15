import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_bam/config/app_config.dart';
import 'package:rastreo_bam/providers/providers.dart' show UiProvider;
import 'package:rastreo_bam/services/auth_service.dart';

import 'package:rastreo_bam/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: AppConfig.appBarHeight,
          title: (AuthService.userName.isEmpty)
              ? const Text(AppConfig.appName)
              : Column(
                  children: [
                    const Text(AppConfig.appName),
                    Text(
                      AuthService.userName,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                AuthService.logout(context);
              },
              icon: const Icon(Icons.exit_to_app, size: 25),
            )
          ],
        ),
        body: const _HomePageBody(),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UiProvider uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.currentIndex;

    switch (currentIndex) {
      case 0:
        return const ScanScreen();
      case 1:
        return const HistoryScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const ScanScreen();
    }
  }
}
