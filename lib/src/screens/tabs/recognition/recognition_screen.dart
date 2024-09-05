import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/amount_card/amount_card.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/filters/recognition_filters.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/peer_to_peer.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/team/team.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/tabs/received_history_tab.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/tabs/sent_history_tab.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  static const screenTitle = "Recognition";

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    void handleOpenFilter() {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) => const RecognitionFilters(
          initialSortByFilter: null,
          initialTimeFilter: null,
          initialTypeFilter: null,
        ),
      );
    }

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
                        title: "Total Sent",
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
                        title: "Total Receive",
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
                const Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                IconButton(
                  onPressed: handleOpenFilter,
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ],
            ),
            TabBar(
              indicatorColor: theme.colorScheme.primary,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [
                Tab(text: "Sent"),
                Tab(text: "Received"),
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
