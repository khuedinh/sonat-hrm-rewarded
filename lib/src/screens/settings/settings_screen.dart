import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/screens/settings/widgets/block_picker.dart';
import 'package:sonat_hrm_rewarded/src/service/firebase/cloud_message.dart';
import 'package:sonat_hrm_rewarded/src/theme/bloc/theme_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _fCMToken;
  void changeColor(Color color) =>
      BlocProvider.of<ThemeBloc>(context).add(ChangeColorEvent(color));

  @override
  void initState() {
    super.initState();
    CloudMessage.firebaseMessaging.getToken().then((value) => setState(() {
          _fCMToken = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeData theme = Theme.of(context);
        ColorScheme colorScheme = theme.colorScheme;
        final themeBloc = BlocProvider.of<ThemeBloc>(context);
        bool isDarkMode = state.isDarkMode;
        Color currentColor = state.color;
        List<Color> colorHistory = state.colorHistory ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings",
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            actions: const [],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dark_mode,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    Switch(
                      trackOutlineWidth:
                          const WidgetStatePropertyAll<double>(0),
                      value: isDarkMode,
                      onChanged: (bool value) {
                        themeBloc.add(ToggleThemeEvent());
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.theme_color,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlockColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                  colorHistory: colorHistory,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     const Text('Copy FCM Token'),
                //     IconButton(
                //       onPressed: _fCMToken != null
                //           ? () =>
                //               Clipboard.setData(ClipboardData(text: _fCMToken!))
                //                   .then((value) {
                //                 ScaffoldMessenger.of(context)
                //                   ..hideCurrentSnackBar()
                //                   ..showSnackBar(const SnackBar(
                //                     content:
                //                         Text('Copied FCM token to clipboard'),
                //                   ));
                //               })
                //           : null,
                //       icon: const Icon(Icons.copy_outlined),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
