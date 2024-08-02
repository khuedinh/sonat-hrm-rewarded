import 'package:flutter/material.dart';
import 'package:sonat_bi_flutter/src/screens/home/screens/account/account_screen.dart';
import 'package:sonat_bi_flutter/src/screens/home/screens/benefit/benefit_screen.dart';
import 'package:sonat_bi_flutter/src/screens/home/screens/recognition/recognition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
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
            icon: Icon(Icons.workspace_premium_outlined),
            label: 'Recognition',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Benefit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        RecognitionScreen(),

        /// Notifications page
        BenefitScreen(),

        /// Messages page
        AccountScreen(),
      ][currentPageIndex],
    );
  }
}
