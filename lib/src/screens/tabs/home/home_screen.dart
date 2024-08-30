import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/models/user.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/notifications_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/widgets/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/widgets/leaderboard_item.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.handleOpenRecognitionScreen});

  static const screenTitle = 'Home';

  final void Function() handleOpenRecognitionScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleOpenNotifications() {
    context.push(NotificationsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 96,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenTitle(
                title: "Leaderboard",
                color: theme.colorScheme.onSurface,
                fontSize: 18,
              ),
              Column(
                children: [
                  for (int i = 0; i < listLeaderboard.length; i++)
                    LeaderboardItem(index: i, item: listLeaderboard[i]),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          height: kToolbarHeight + 54,
        ),
        Card(
          elevation: 4,
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            1,
          ),
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 94,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final UserInfo? userInfo = state.userInfo;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DisplayAmount(
                      amount: formatShortenNumber(
                        userInfo?.balance.currentPoint ?? 0,
                      ),
                      icon: Icons.attach_money_rounded,
                      suffix: "Points",
                      iconSize: 14,
                    ),
                    DisplayAmount(
                      amount: formatShortenNumber(
                        userInfo?.balance.currentCoin ?? 0,
                      ),
                      icon: Icons.currency_bitcoin_rounded,
                      suffix: "Coins",
                      iconSize: 14,
                    ),
                    SizedBox(
                      height: 28,
                      child: FilledButton.icon(
                        onPressed: widget.handleOpenRecognitionScreen,
                        style: ButtonStyle(
                          iconSize: WidgetStateProperty.all<double>(20),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.present_to_all_rounded),
                        label: const Text("Recognize"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: const ScreenTitle(title: HomeScreen.screenTitle),
            actions: [
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Badge.count(
                      count: state.unreadCount,
                      child: const Icon(Icons.notifications),
                    ),
                    color: theme.colorScheme.onPrimary,
                    onPressed: _handleOpenNotifications,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
