import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/app/bloc/app_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/models/user.dart';
import 'package:sonat_hrm_rewarded/src/screens/settings/settings_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/account/widgets/overview_card.dart';
import 'package:sonat_hrm_rewarded/src/screens/transaction_history/transaction_history_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

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
        "title": AppLocalizations.of(context)!.transaction_history,
        "icon": Icons.history_rounded,
        "onTab": (BuildContext context) =>
            context.push(TransactionHistoryScreen.routeName),
      },
      {
        "title": AppLocalizations.of(context)!.settings,
        "icon": Icons.settings,
        "onTab": (BuildContext context) =>
            context.push(SettingsScreen.routeName),
      },
      {
        "title": AppLocalizations.of(context)!.logout,
        "icon": Icons.logout,
        "onTab": (BuildContext context) {
          handleSignOut();
        },
      }
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: <Widget>[
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final bool isLoadingUserInfo = state.isLoadingUserInfo;
            final UserInfo? userInfo = state.userInfo;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (isLoadingUserInfo)
                      const Skeletonizer(
                        child: Bone.circle(size: 80),
                      ),
                    if (userInfo?.picture != null)
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userInfo?.picture ?? "",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/default_avatar.png",
                                fit: BoxFit.cover,
                              ), // Optional: Error widget
                            ),
                          ),
                        ),
                      ),
                    if (!isLoadingUserInfo && userInfo?.picture == null)
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
                    isLoadingUserInfo
                        ? const Skeletonizer(
                            child: Bone.text(words: 2, fontSize: 20))
                        : Text(
                            userInfo?.name ?? "",
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    isLoadingUserInfo
                        ? const Skeletonizer(
                            child: Bone.text(words: 2, fontSize: 16),
                          )
                        : Text(
                            userInfo?.email ?? "",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OverviewCard(
                            color: Colors.green,
                            icon: Icons.workspace_premium,
                            title: AppLocalizations.of(context)!
                                .received_recognitions,
                            value:
                                userInfo?.userRecognition.totalRecognition ?? 0,
                            isLoading: isLoadingUserInfo,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OverviewCard(
                            color: const Color.fromARGB(255, 255, 154, 59),
                            icon: Icons.card_giftcard,
                            title:
                                AppLocalizations.of(context)!.active_benefits,
                            value: userInfo?.activeBenefit ?? 0,
                            isLoading: isLoadingUserInfo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
