import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/amount_card/amount_card.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/filters/recognition_filters.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/peer_to_peer.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/team/team.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/tabs/received_history_tab.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/tabs/sent_history_tab.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  void _handleOpenFilter() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) => RecognitionFilters(
        initSortBy: context.read<RecognitionBloc>().state.sortBy,
        initTimeRange: context.read<RecognitionBloc>().state.timeRange,
        initType: context.read<RecognitionBloc>().state.type,
        initStartDate: context.read<RecognitionBloc>().state.startDate,
        initEndDate: context.read<RecognitionBloc>().state.endDate,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RecognitionBloc>(context).add(FetchListRecipients());
    BlocProvider.of<RecognitionBloc>(context).add(FetchListRecognitionValues());
    BlocProvider.of<RecognitionBloc>(context).add(FetchListGroups());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PeerToPeer()),
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person),
                        Text(
                          "P2P",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Team()),
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group),
                        Text("Team"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.card_membership),
                        Text("E-Card"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            BlocBuilder<RecognitionBloc, RecognitionState>(
              builder: (context, state) {
                final isLoading = state.isLoadingRecognitionHistory;
                final sentHistory = state.sentHistory;
                final receiveHistory = state.receivedHistory;

                return Row(
                  children: [
                    Expanded(
                      child: AmountCard(
                        isLoading: isLoading,
                        icon: Icons.output_rounded,
                        iconColor: Colors.red,
                        title: AppLocalizations.of(context)!.total_sent,
                        amount: sentHistory.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.amount,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: AmountCard(
                        isLoading: isLoading,
                        icon: Icons.input_rounded,
                        iconColor: Colors.green,
                        title: AppLocalizations.of(context)!.total_received,
                        amount: receiveHistory.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.amount,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.history,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                BlocBuilder<RecognitionBloc, RecognitionState>(
                    builder: (context, state) {
                  int filterCount = 0;
                  if (state.startDate != null && state.endDate != null) {
                    filterCount++;
                  }
                  if (state.sortBy != null) filterCount++;
                  if (state.type != null) filterCount++;
                  return IconButton(
                    icon: filterCount > 0
                        ? Badge.count(
                            count: filterCount,
                            child: const Icon(Icons.filter_alt_rounded))
                        : const Icon(Icons.filter_alt_outlined),
                    onPressed: _handleOpenFilter,
                  );
                }),
              ],
            ),
            TabBar(
              indicatorColor: theme.colorScheme.primary,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: [
                Tab(text: AppLocalizations.of(context)!.sent),
                Tab(text: AppLocalizations.of(context)!.received),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<RecognitionBloc, RecognitionState>(
                    builder: (context, state) {
                      final isLoading = state.isLoadingRecognitionHistory;
                      final sentHistory = state.sentHistory;
                      return SentHistoryTab(
                        isLoading: isLoading,
                        sentHistory: sentHistory,
                      );
                    },
                  ),
                  BlocBuilder<RecognitionBloc, RecognitionState>(
                    builder: (context, state) {
                      final isLoading = state.isLoadingRecognitionHistory;
                      final receiveHistory = state.receivedHistory;
                      return ReceivedHistoryTab(
                        isLoading: isLoading,
                        receiveHistory: receiveHistory,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
