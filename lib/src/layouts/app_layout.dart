// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:sonat_hrm_rewarded/src/screens/settings/settings_screen.dart';

// class AppLayout extends StatefulWidget {
//   const AppLayout(
//       {super.key,
//       required this.screenTitle,
//       required this.body,
//       this.showBackButton,
//       this.buildEndDrawer,
//       this.floatButton});

//   final dynamic screenTitle;
//   final Widget body;
//   final bool? showBackButton;
//   final Widget? buildEndDrawer;
//   final Widget? floatButton;

//   @override
//   State<AppLayout> createState() => _AppLayoutState();
// }

// class _AppLayoutState extends State<AppLayout> {
//   late StreamSubscription<RemoteMessage> onMessageOpenedAppStream;
//   String version = '';

//   @override
//   void initState() {
//     super.initState();

//     PackageInfo.fromPlatform().then((packageInfo) {
//       setState(() {
//         version = packageInfo.version;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     onMessageOpenedAppStream.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     ColorScheme colorScheme = theme.colorScheme;
//     final String currentPath =
//         GoRouter.of(context).routeInformationProvider.value.uri.toString();
//     final user = FirebaseAuth.instance.currentUser;
//     final name = user?.displayName ?? '';
//     final email = user?.email ?? '';
//     final avatar = user?.photoURL ?? '';
//     final permissions = context.read<CommonDataBloc>().state.permissions;

//     void handleSignOut() async {
//       try {
//         context.read<AppBloc>().add(AppLogoutRequested());
//       } catch (e) {
//         debugPrint('$e');
//       }
//     }

//     List<Map<String, dynamic>> routeList = [
//       {
//         'path': MyAppScreen.routeName,
//         'leading': Icons.home_outlined,
//         'title': 'My Apps',
//         'onTap': (BuildContext context) => context.go(MyAppScreen.routeName),
//       },
//       {
//         'path': AccountOverviewScreen.routeName,
//         'leading': Icons.bar_chart_outlined,
//         'title': 'Account Overview',
//         'onTap': (BuildContext context) =>
//             context.go(AccountOverviewScreen.routeName),
//       },
//       {
//         'path': NotificationScreen.routeName,
//         'leading': Icons.notifications_outlined,
//         'title': 'Notification',
//         'onTap': (BuildContext context) =>
//             context.go(NotificationScreen.routeName),
//       },
//       {
//         'path': SettingsScreen.routeName,
//         'leading': Icons.settings_outlined,
//         'title': 'Settings',
//         'onTap': (BuildContext context) => context.go(SettingsScreen.routeName),
//       },
//       {
//         'path': '',
//         'leading': Icons.logout_outlined,
//         'title': 'Logout',
//         'onTap': (BuildContext context) => handleSignOut(),
//       },
//     ];

//     if (getSystemManagePermssion()) {
//       routeList.insert(2, {
//         'path': SystemManagementScreen.routeName,
//         'leading': Icons.manage_history_outlined,
//         'title': 'System Management',
//         'onTap': (BuildContext context) =>
//             context.go(SystemManagementScreen.routeName),
//       });
//     }
//     if (getAppReportPermission()) {
//       routeList.insert(3, {
//         'path': AppReportScreen.routeName,
//         'leading': Icons.data_thresholding_outlined,
//         'title': 'Raw Data',
//         'onTap': (BuildContext context) =>
//             context.go(AppReportScreen.routeName),
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: widget.screenTitle is Widget
//             ? widget.screenTitle
//             : Text(
//                 widget.screenTitle,
//                 style: TextStyle(color: colorScheme.onPrimary),
//               ),
//         centerTitle: true,
//         backgroundColor: colorScheme.primary,
//         foregroundColor: colorScheme.onPrimary,
//         titleTextStyle: const TextStyle(fontSize: 18),
//         leading: Builder(
//             builder: (context) => widget.showBackButton == true
//                 ? IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back),
//                   )
//                 : IconButton(
//                     onPressed: () => Scaffold.of(context).openDrawer(),
//                     icon: const Icon(Icons.menu),
//                   )),
//         actions: [
//           widget.buildEndDrawer != null
//               ? Builder(builder: (context) {
//                   return IconButton(
//                     onPressed: () => Scaffold.of(context).openEndDrawer(),
//                     icon: const Icon(Icons.filter_alt_outlined),
//                   );
//                 })
//               : const SizedBox()
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: colorScheme.surface,
//         shape: const BeveledRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.zero)),
//         child: Container(
//           decoration: BoxDecoration(color: colorScheme.surface),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     UserAccountsDrawerHeader(
//                       decoration: BoxDecoration(color: colorScheme.surface),
//                       accountName: Text(
//                         name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       accountEmail: Text(
//                         email,
//                         style: TextStyle(
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       currentAccountPicture: CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           avatar,
//                         ),
//                       ),
//                     ),
//                     ...routeList.map(
//                       (item) {
//                         bool isSelected =
//                             currentPath.compareTo(item['path']) == 0;
//                         return ListTile(
//                           leading: Icon(item['leading'] as IconData),
//                           title:
//                               BlocBuilder<NotificationBloc, NotificationState>(
//                             builder: (context, state) {
//                               return Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     item['title'] as String,
//                                     style: TextStyle(
//                                         fontWeight: isSelected
//                                             ? FontWeight.w700
//                                             : FontWeight.w400),
//                                   ),
//                                   state.unreadCount > 0 &&
//                                           NotificationScreen.routeName
//                                                   .compareTo(item['path']) ==
//                                               0
//                                       ? Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 2, horizontal: 10),
//                                           decoration: BoxDecoration(
//                                               color: theme.colorScheme.error,
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(20))),
//                                           child: Text(
//                                             state.unreadCount.toString(),
//                                             style: TextStyle(
//                                                 color:
//                                                     theme.colorScheme.onError),
//                                           ))
//                                       : const SizedBox()
//                                 ],
//                               );
//                             },
//                           ),
//                           onTap: () => item['onTap'](context),
//                           selectedColor: colorScheme.primary,
//                           selected: isSelected,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: Text('Version: $version'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       body: Container(color: colorScheme.surface, child: widget.body),
//     );
//   }
// }
