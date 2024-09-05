import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/notifications_screen.dart';
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

  void _handleOpenRecognition() {
    setState(() {
      currentPageIndex = 1;
    });
  }

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
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Badge.count(
                        count: state.unreadCount,
                        child: const Icon(Icons.notifications),
                      ),
                      color: theme.colorScheme.onPrimary,
                      onPressed: () {
                        context.push(NotificationsScreen.routeName);
                      },
                    );
                  },
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
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.workspace_premium),
            icon: Icon(Icons.workspace_premium_outlined),
            label: 'Recognition',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.card_giftcard),
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Benefits',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(handleOpenRecognitionScreen: _handleOpenRecognition),
        const RecognitionScreen(),
        const BenefitsScreen(),
        const AccountScreen(),
      ][currentPageIndex],
    );
  }
}
