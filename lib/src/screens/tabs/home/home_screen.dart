import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/display_amount/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/notifications_screen.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/bloc/home_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/home/widgets/leaderboard_item.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.handleOpenRecognitionScreen});

  static const screenTitle = 'Home';

  final void Function() handleOpenRecognitionScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  bool _isScrolledDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(FetchCurrentBalance());
  }

  void _onScroll() {
    final currentScroll = _scrollController.offset;
    setState(() {
      _isScrolledDown = currentScroll >= 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: RefreshableWidget(
        controller: _scrollController,
        onRefresh: () async {
          context.read<HomeBloc>().add(FetchLeaderboard());
          context.read<UserBloc>().add(RefreshCurrentBalance());
        },
        slivers: [
          SliverAppBar(
            pinned: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(_isScrolledDown ? 0 : 32),
                bottomRight: Radius.circular(_isScrolledDown ? 0 : 32),
              ),
            ),
            expandedHeight: kToolbarHeight + 36,
            backgroundColor: theme.colorScheme.primary,
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
                    onPressed: () {
                      context.push(NotificationsScreen.routeName);
                    },
                  );
                },
              ),
            ],
            flexibleSpace: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: _isScrolledDown ? 28 : 16,
                  right: _isScrolledDown ? 54 : 16,
                  bottom: _isScrolledDown ? kToolbarHeight - 38 : 0,
                  child: Card(
                    color: _isScrolledDown ? theme.colorScheme.primary : null,
                    margin: EdgeInsets.only(
                        top: _isScrolledDown ? 0 : kToolbarHeight),
                    elevation: _isScrolledDown ? 0 : 4,
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      1,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _isScrolledDown ? 0 : 4,
                        horizontal: _isScrolledDown ? 0 : 12,
                      ),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          final isLoading = state.isLoadingCurrentBalance;
                          final currentBalance = state.currentBalance;

                          return Row(
                            mainAxisAlignment: _isScrolledDown
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              DisplayAmount(
                                isLoading: isLoading,
                                amount: formatShortenNumber(
                                  currentBalance?.currentPoint ?? 0,
                                ),
                                textColor:
                                    _isScrolledDown ? Colors.white : null,
                                icon: Icons.attach_money_rounded,
                                suffix: "Points",
                                spacing: 4,
                                iconSize: 12,
                              ),
                              if (_isScrolledDown) const SizedBox(width: 8),
                              DisplayAmount(
                                isLoading: isLoading,
                                amount: formatShortenNumber(
                                    currentBalance?.currentCoin ?? 0),
                                textColor:
                                    _isScrolledDown ? Colors.white : null,
                                icon: Icons.currency_bitcoin_rounded,
                                suffix: "Coins",
                                spacing: 4,
                                iconSize: 12,
                              ),
                              if (!_isScrolledDown)
                                SizedBox(
                                  height: 28,
                                  child: FilledButton.icon(
                                    onPressed:
                                        widget.handleOpenRecognitionScreen,
                                    style: ButtonStyle(
                                      iconSize:
                                          WidgetStateProperty.all<double>(20),
                                      padding:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                        Icons.present_to_all_rounded),
                                    label: const Text("Recognize"),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: ScreenTitle(
                title: "Leaderboard",
                color: theme.colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final listLeaderboard = state.listLeaderboard.length > 5
                  ? state.listLeaderboard.sublist(0, 5)
                  : state.listLeaderboard;
              final isLoadingLeaderboard = state.isLoadingLeaderboard;

              if (isLoadingLeaderboard) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      return const Skeletonizer(
                        child: Card(
                          child: ListTile(
                            leading: Bone.circle(size: 36),
                            title: Bone.text(words: 3),
                            trailing: Bone.text(words: 1),
                          ),
                        ),
                      );
                    },
                    itemCount: 5,
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList.builder(
                  itemBuilder: (context, index) {
                    return LeaderboardItem(
                      index: index,
                      item: listLeaderboard[index],
                    );
                  },
                  itemCount: listLeaderboard.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
