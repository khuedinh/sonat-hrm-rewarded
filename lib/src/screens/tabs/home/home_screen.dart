import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_bi_flutter/src/widgets/home/display_amount.dart';
import 'package:sonat_bi_flutter/src/widgets/home/leaderboard_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const screenTitle = 'Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    void _handleOpenNotifications() {
      context.push('/notifications');
    }

    final List<dynamic> leaderboardData = [
      {
        "name": "John Doe",
        "coins": 300,
      },
      {
        "name": "Jane Doe",
        "coins": 200,
      },
      {
        "name": "John Smith",
        "coins": 100,
      },
      {
        "name": "John Smith",
        "coins": 50,
      },
      {
        "name": "John Smith",
        "coins": 30,
      },
    ];

    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DisplayAmount(
                      amount: 3000,
                      icon: Icons.attach_money_rounded,
                      suffix: "Points",
                    ),
                    const SizedBox(width: 12),
                    const DisplayAmount(
                      amount: 2000,
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
                title: Text(
                  HomeScreen.screenTitle,
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
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
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Leaderboard",
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  for (int i = 0; i < leaderboardData.length; i++)
                    LeaderboardItem(index: i, item: leaderboardData[i]),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
