import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/recognition.dart';
import 'package:sonat_hrm_rewarded/src/widgets/recognition/filters/recognition_filters.dart';
import 'package:sonat_hrm_rewarded/src/widgets/recognition/p2p/p2p_tab.dart';
import 'package:sonat_hrm_rewarded/src/widgets/recognition/team/team_tab.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  static const screenTitle = "Recognition";

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {

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
          initialSortByFilter: SortByFilter.latest,
          initialTimeFilter: TimeFilter.last7Days,
          initialTypeFilter: TypeFilter.all,
        ),
      );
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0), // Adjust the padding as needed
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
                            builder: (context) =>
                                const P2pTab()), // Replace NewPage with the actual page class
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
                        MaterialPageRoute(
                            builder: (context) =>
                                const TeamTab()), // Replace NewPage with the actual page class
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
            const Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(
                          8.0), // Optional: Add padding inside the card
                      child: Row(
                        children: [
                          Icon(
                            Icons.output_outlined,
                            color: Colors.red,
                          ),
                          SizedBox(
                              width:
                                  8.0), // Optional: Add spacing between icon and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Sent"),
                              Text("2000 Points"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(
                          8.0), // Optional: Add padding inside the card
                      child: Row(
                        children: [
                          Icon(
                            Icons.input_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(
                              width:
                                  8.0), // Optional: Add spacing between icon and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Received"),
                              Text("1600 Points"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0, // Adjust the font size as needed
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
                Tab(text: "All"),
                Tab(text: "Sent"),
                Tab(text: "Received"),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final notification = historyList[index];
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                        title: Text(
                          notification.name,
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        subtitle: notification.role == null ||
                                notification.role!.isEmpty
                            ? null
                            : Text(notification.role!),
                        trailing: Text(
                          notification.quantity > 0
                              ? '+${notification.quantity.toString()}'
                              : notification.quantity.toString(),
                          style: TextStyle(
                            color: notification.quantity > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.folder_off),
                        onPressed: () {},
                      ),
                      const Text("No data found."),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.folder_off),
                        onPressed: () {},
                      ),
                      const Text("No data found."),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
