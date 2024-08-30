import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const Skeletonizer(
          child: Card(
              margin: EdgeInsets.only(top: 16),
              child: ListTile(
                title: Bone.text(
                  words: 2,
                ),
                leading: Bone.circle(size: 36),
                subtitle: Bone.text(words: 4, fontSize: 12),
                trailing: Bone.text(words: 1, fontSize: 12),
              )),
        );
      },
      itemCount: 6,
    );
  }
}
