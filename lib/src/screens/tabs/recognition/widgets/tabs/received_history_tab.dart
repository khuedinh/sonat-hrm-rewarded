import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/no_data/no_data.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';

class ReceivedHistoryTab extends StatelessWidget {
  const ReceivedHistoryTab(
      {super.key, required this.isLoading, required this.receiveHistory});

  final bool isLoading;
  final List<Recognition> receiveHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Skeletonizer(
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return const ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              leading: Bone.circle(size: 50),
              title: Bone.text(words: 3),
              trailing: Bone.text(words: 1),
            );
          },
        ),
      );
    }

    return RefreshableWidget(
      onRefresh: () async {
        context.read<RecognitionBloc>().add(FetchRecognitionHistory());
      },
      slivers: [
        receiveHistory.isEmpty
            ? const SliverToBoxAdapter(
                child: SizedBox(
                    height: 300,
                    child: NoData(message: "No recognition history")),
              )
            : ListView.builder(
                itemCount: receiveHistory.length,
                itemBuilder: (context, index) {
                  final recognition = receiveHistory[index];
                  return ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 24,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: recognition.employee.picture,
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
                      recognition.employee.name,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    trailing: Text(
                      recognition.amount > 0
                          ? '+${recognition.amount.toString()}'
                          : recognition.amount.toString(),
                      style: TextStyle(
                        color:
                            recognition.amount > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    onTap: () {},
                  );
                },
              )
      ],
    );
  }
}
