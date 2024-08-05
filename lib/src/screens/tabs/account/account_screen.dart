import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_bi_flutter/src/screens/settings/settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const screenTitle = "Account";

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final List<Map<String, dynamic>> menuList = [
    {
      "title": "Overview",
      "icon": Icons.dashboard,
      "onTab": (BuildContext context) => {},
    },
    {
      "title": "Settings",
      "icon": Icons.settings,
      "onTab": (BuildContext context) => context.push(SettingsScreen.routeName),
    },
    {
      "title": "Logout",
      "icon": Icons.logout,
      "onTab": (BuildContext context) {},
    }
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: <Widget>[
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(
                  Icons.person,
                  size: 50,
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
            ],
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
