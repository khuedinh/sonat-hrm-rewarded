import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_bi_flutter/src/packages/authentication_repository/lib/src/authentication_repository.dart';
import 'package:sonat_bi_flutter/src/screens/error/error_screen.dart';
import 'package:sonat_bi_flutter/src/screens/notifications/notifications_screen.dart';
import 'package:sonat_bi_flutter/src/screens/tabs/tabs_screen.dart';
import 'package:sonat_bi_flutter/src/screens/settings/settings_screen.dart';
import 'package:sonat_bi_flutter/src/theme/bloc/theme_bloc.dart';
import 'package:sonat_bi_flutter/src/theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  final GoRouter router = GoRouter(
    initialLocation: TabsScreen.routeName,
    // redirect: (context, state) {
    //   if (FirebaseAuth.instance.currentUser == null) {
    //     return LoginScreen.routeName;
    //   }
    //   if (state.fullPath == LoginScreen.routeName) {
    //     return HomeScreen.routeName;
    //   }
    //   return null;
    // },
    errorBuilder: (context, state) => const ErrorScreen(),
    routes: [
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
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc()..add(InitialThemeEvent()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',

              // To turn off debug banner when debugging
              debugShowCheckedModeBanner: false,

              // Provide the generated AppLocalizations to the MaterialApp. This
              // allows descendant Widgets to display the correct translations
              // depending on the user's locale.
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,

              // Use AppLocalizations to configure the correct application title
              // depending on the user's locale.
              //
              // The appTitle is defined in .arb files found in the localization
              // directory.
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: CustomAppTheme.getLightTheme(themeState.color),
              darkTheme: CustomAppTheme.getDarkTheme(themeState.color),
              themeMode:
                  themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              routerConfig: router,
              builder: (context, child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
