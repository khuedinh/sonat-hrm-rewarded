import 'package:flutter/material.dart';
import 'package:sonat_bi_flutter/src/screens/tabs/account/account_screen.dart';
import 'package:sonat_bi_flutter/src/screens/tabs/benefits/benefits_screen.dart';
import 'package:sonat_bi_flutter/src/screens/tabs/home/home_screen.dart';
import 'package:sonat_bi_flutter/src/screens/tabs/recognition/recognition_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  static const routeName = '/tab';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final String screenTitle = [
      HomeScreen.screenTitle,
      RecognitionScreen.screenTitle,
      BenefitsScreen.screenTitle,
      AccountScreen.screenTitle,
    ][currentPageIndex];

    final hasCustomAppBar = currentPageIndex == 0;

    return Scaffold(
      appBar: hasCustomAppBar
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.8),
                      theme.colorScheme.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: AppBar(
                  title: Text(screenTitle),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: theme.colorScheme.onPrimary,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            label: 'Recognition',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Benefits',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        const HomeScreen(), // Home page
        const RecognitionScreen(), // Recognition page
        const BenefitsScreen(), // Benefit page
        const AccountScreen(), // Account page
      ][currentPageIndex],
    );
  }
}
