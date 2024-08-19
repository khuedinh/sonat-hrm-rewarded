import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/app/bloc/app_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/transaction_history_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/settings/settings_screen.dart';
import 'package:sonat_hrm_rewarded/src/widgets/account/overview_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const screenTitle = "Account";

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void handleSignOut() async {
    try {
      context.read<AppBloc>().add(AppLogoutRequested());
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final List<Map<String, dynamic>> menuList = [
      {
        "title": "Transaction history",
        "icon": Icons.history_rounded,
        "onTab": (BuildContext context) =>
            context.push(TransactionHistoryScreen.routeName),
      },
      {
        "title": "Settings",
        "icon": Icons.settings,
        "onTab": (BuildContext context) =>
            context.push(SettingsScreen.routeName),
      },
      {
        "title": "Logout",
        "icon": Icons.logout,
        "onTab": (BuildContext context) {
          handleSignOut();
        },
      }
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sonat BI Team",
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "bi.sonat@sonat.vn",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: OverviewCard(
                        color: Colors.green,
                        icon: Icons.workspace_premium,
                        title: "Received recognitions",
                        value: 3,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OverviewCard(
                        color: Color.fromARGB(255, 255, 154, 59),
                        icon: Icons.card_giftcard,
                        title: "Active benefits",
                        value: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
        ...menuList.map((item) {
          return ListTile(
            leading: Icon(item["icon"]),
            title: Text(item["title"]),
            onTap: () => item["onTab"](context),
          );
        })
      ],
    );
  }
}
