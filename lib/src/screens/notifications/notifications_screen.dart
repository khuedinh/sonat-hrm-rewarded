import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/activity_indicator/activity_indicator.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/bloc/notification_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/notifications/widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static const routeName = '/notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context.read<NotificationBloc>().add(GetNotiListEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<NotificationBloc>().add(const LoadNotiEvent());
    }
  }

  Future<void> _onRefresh() async {
    context.read<NotificationBloc>().add(const RefreshEvent());
    await context.read<NotificationBloc>().stream.firstWhere(
          (state) => state.isRefreshLoading == false,
        );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    final logger = Logger();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: ScreenTitle(title: AppLocalizations.of(context)!.notification),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Container(
        color: colorScheme.surface,
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final itemList = state.notiList;
            final hasReachedMax = state.hasReachedMax;

            return state.isLoading
                ? const Center(child: ActivityIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: itemList.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child:
                                        Text("You don't have any notification"),
                                  )
                                ],
                              )
                            : RefreshableWidget(
                                controller: _scrollController,
                                onRefresh: _onRefresh,
                                slivers: [
                                  SliverList.separated(
                                    itemCount: hasReachedMax
                                        ? itemList.length
                                        : itemList.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return index >= itemList.length
                                          ? const Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Center(
                                                  child: ActivityIndicator()),
                                            )
                                          : NotificationItem(
                                              data: itemList[index],
                                            );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return index < itemList.length - 1
                                          ? const Divider(
                                              height: 1,
                                            )
                                          : const SizedBox();
                                    },
                                  )
                                ],
                              ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
