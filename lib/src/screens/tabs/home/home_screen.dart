import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/leaderboard_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const screenTitle = 'Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleOpenNotifications() {
    context.push('/notifications');
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DisplayAmount(
                  amount: currentUser.point,
                  icon: Icons.attach_money_rounded,
                  suffix: "Points",
                ),
                const SizedBox(width: 12),
                DisplayAmount(
                  amount: currentUser.coin,
                  icon: Icons.currency_bitcoin_rounded,
                  suffix: "Coins",
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 32,
                  child: FilledButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      iconSize: WidgetStateProperty.all<double>(20),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.present_to_all_rounded),
                    label: const Text("Recognize"),
                  ),
                ),
              ],
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
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: theme.colorScheme.onPrimary,
                onPressed: _handleOpenNotifications,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
