import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/filters/recognition_filters.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/p2p/p2p_tab.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/team/team_tab.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  static const screenTitle = "Recognition";

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  List<Recognition> sentNotifications = [];
  List<Recognition> receivedNotifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await RecognitionApi.getHistory();

    if (mounted) {
      setState(() {
        sentNotifications = (response['sent'] as List)
            .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
            .toList();
        receivedNotifications = (response['received'] as List)
            .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    }
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
          initialSortByFilter: SortByFilter.latest,
          initialTimeFilter: TimeFilter.last7Days,
          initialTypeFilter: TypeFilter.all,
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
                        MaterialPageRoute(builder: (context) => const P2pTab()),
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
                            builder: (context) => const TeamTab()),
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
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.output_outlined,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Sent"),
                              isLoading
                                  ? const Skeletonizer(
                                      child: Text("10000 Points"),
                                    )
                                  : sentNotifications.isEmpty
                                      ? const Text("0 Points")
                                      : Text(
                                          "${sentNotifications.fold(0, (previousValue, element) => previousValue + element.amount)} Points",
                                        ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.input_outlined,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Received"),
                              isLoading
                                  ? const Skeletonizer(
                                      child: Text("10000 Points"),
                                    )
                                  : receivedNotifications.isEmpty
                                      ? const Text("0 Points")
                                      : Text(
                                          "${receivedNotifications.fold(0, (previousValue, element) => previousValue + element.amount)} Points",
                                        ),
                            ],
                          )
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
                  // isLoading
                  //     ? ListView.builder(
                  //         itemCount: 3,
                  //         itemBuilder: (context, index) {
                  //           return ListTile(
                  //             titleAlignment: ListTileTitleAlignment.center,
                  //             leading: SizedBox(
                  //               width: 50,
                  //               height: 50,
                  //               child: Skeletonizer(
                  //                 child: Container(
                  //                   width: 48,
                  //                   height: 48,
                  //                   decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     color: Colors.grey[300],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             title: Skeletonizer(
                  //               child: Container(
                  //                 width: 40,
                  //                 height: 20,
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.grey[300],
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //               ),
                  //             ),
                  //             trailing: Skeletonizer(
                  //               child: Container(
                  //                 width: 40,
                  //                 height: 20,
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.grey[300],
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //               ),
                  //             ),
                  //             onTap: () {},
                  //           );
                  //         },
                  //       )
                  isLoading
                      ? Skeletonizer(
                          enabled: isLoading,
                          child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              return ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    radius: 24,
                                  ),
                                ),
                                title: const Text("Pham Van Thach"),
                                trailing: const Text("+1000"),
                                onTap: () {},
                              );
                            },
                          ),
                        )
                      : sentNotifications.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.folder_off),
                                  onPressed: () {},
                                ),
                                const Text("No data found."),
                              ],
                            )
                          : ListView.builder(
                              itemCount: (sentNotifications).length,
                              itemBuilder: (context, index) {
                                final notification = sentNotifications[index];
                                return ListTile(
                                  titleAlignment: ListTileTitleAlignment.center,
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircleAvatar(
                                      radius: 24,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: (notification
                                                          .detailRecognitions !=
                                                      null &&
                                                  notification
                                                      .detailRecognitions!
                                                      .isNotEmpty)
                                              ? notification
                                                  .detailRecognitions![0]
                                                  .employee
                                                  .picture
                                              : "",
                                          fit: BoxFit.cover,
                                          width: 48,
                                          height: 48,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    (notification.detailRecognitions != null &&
                                            notification
                                                .detailRecognitions!.isNotEmpty)
                                        ? notification.detailRecognitions![0]
                                            .employee.name
                                        : "",
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  trailing: Text(
                                    notification.amount > 0
                                        ? '+${notification.amount.toString()}'
                                        : notification.amount.toString(),
                                    style: TextStyle(
                                      color: notification.amount > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  onTap: () {},
                                );
                              },
                            ),
                  isLoading
                      ? Skeletonizer(
                          enabled: isLoading,
                          child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              return ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    radius: 24,
                                  ),
                                ),
                                title: const Text("Pham Van Thach"),
                                trailing: const Text("+1000"),
                                onTap: () {},
                              );
                            },
                          ),
                        )
                      : receivedNotifications.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.folder_off),
                                  onPressed: () {},
                                ),
                                const Text("No data found."),
                              ],
                            )
                          : ListView.builder(
                              itemCount: receivedNotifications.length,
                              itemBuilder: (context, index) {
                                final notification =
                                    receivedNotifications[index];
                                return ListTile(
                                  titleAlignment: ListTileTitleAlignment.center,
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircleAvatar(
                                      radius: 24,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              notification.employee.picture,
                                          fit: BoxFit.cover,
                                          width: 48,
                                          height: 48,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    notification.employee.name,
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  trailing: Text(
                                    notification.amount > 0
                                        ? '+${notification.amount.toString()}'
                                        : notification.amount.toString(),
                                    style: TextStyle(
                                      color: notification.amount > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  onTap: () {},
                                );
                              },
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
