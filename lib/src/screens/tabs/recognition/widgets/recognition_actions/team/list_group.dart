import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/team/group_item.dart';

class ListGroups extends StatelessWidget {
  const ListGroups({
    super.key,
    required this.isLoading,
    required this.listGroups,
    required this.selectedGroup,
    required this.onSelectGroup,
  });

  final bool isLoading;
  final List<Group> listGroups;
  final String? selectedGroup;
  final void Function(Group) onSelectGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 90,
          child: Skeletonizer(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 16);
              },
              itemBuilder: (context, index) {
                return const Column(
                  children: [
                    Expanded(
                      child: Bone.circle(size: 36),
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: SizedBox(
                        width: 70,
                        child: Bone.text(words: 2, fontSize: 11),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    if (listGroups.isEmpty) {
      return SliverToBoxAdapter(
        child: Text(
          'No groups found.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 4),
          scrollDirection: Axis.horizontal,
          itemCount: listGroups.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 4);
          },
          itemBuilder: (context, index) {
            final group = listGroups[index];

            return GestureDetector(
              onTap: () {
                onSelectGroup(group);
              },
              child: GroupItem(
                isSelected: group.id == selectedGroup,
                name: group.name,
                wrapName: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
