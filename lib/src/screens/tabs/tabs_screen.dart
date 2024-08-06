import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/account/account_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/benefits_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/home_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/recognition_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  static const routeName = '/tabs';

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

    final hasCustomAppBar = [0, 2].contains(currentPageIndex);

    return Scaffold(
      appBar: hasCustomAppBar
          ? null
          : AppBar(
              title: ScreenTitle(title: screenTitle),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
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
