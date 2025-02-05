import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sonat_hrm_rewarded/src/app/bloc/app_bloc.dart';
import 'package:sonat_hrm_rewarded/src/app/router.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/packages/authentication_repository/authentication_repository.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/notifications_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/bloc/home_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/theme/bloc/theme_bloc.dart';
import 'package:sonat_hrm_rewarded/src/theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<RemoteMessage> onMessageOpenedAppStream;
  final router = AppRouter.router;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message == null) return;
      router.push(NotificationsScreen.routeName);
    });

    onMessageOpenedAppStream = FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? message) async {
      if (message == null) return;
      router.push(NotificationsScreen.routeName);
    });
  }

  @override
  void dispose() {
    onMessageOpenedAppStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: widget._authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => ThemeBloc()..add(InitialThemeEvent()),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(),
          ),
          BlocProvider(
            create: (context) => UserBloc()..add(FetchUserInfo()),
          ),
          BlocProvider(
            create: (context) => HomeBloc()..add(FetchLeaderboard()),
          ),
          BlocProvider(
            create: (context) =>
                RecognitionBloc()..add(FetchRecognitionHistory()),
          ),
          BlocProvider(create: (context) => BenefitsBloc()),
        ],
        child: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            router.refresh();
          },
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
                    data:
                        data.copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
