import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_archived_box/benefit_archived_box_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_details/benefit_details_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/error/error_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/login/login_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/notifications_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/settings/settings_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/tabs_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/transaction_history_screen.dart';

class AppRouter {
  static GoRouter get router => _goRouter;

  static final GoRouter _goRouter = GoRouter(
    initialLocation: TabsScreen.routeName,
    redirect: (context, state) {
      if (FirebaseAuth.instance.currentUser == null) {
        return LoginScreen.routeName;
      }
      if (state.fullPath == LoginScreen.routeName) {
        return TabsScreen.routeName;
      }
      return null;
    },
    errorBuilder: (context, state) => const ErrorScreen(),
    routes: [
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: TabsScreen.routeName,
        builder: (context, state) => const TabsScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: NotificationsScreen.routeName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: BenefitDetailScreen.routeName,
        builder: (context, state) {
          BenefitResponse benefit = state.extra as BenefitResponse;
          return BenefitDetailScreen(benefit: benefit);
        },
      ),
      GoRoute(
        path: BenefitArchivedBoxScreen.routeName,
        builder: (context, state) => const BenefitArchivedBoxScreen(),
      ),
      GoRoute(
        path: TransactionHistoryScreen.routeName,
        builder: (context, state) => const TransactionHistoryScreen(),
      )
    ],
  );
}
