import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/employee_item.dart';

class ListEmployees extends StatelessWidget {
  const ListEmployees({
    super.key,
    required this.isLoading,
    required this.listEmployees,
    required this.onSelectEmployee,
    this.isShowAddMore = false,
    this.onAddMoreRecipients,
  });

  final List<Employee> listEmployees;
  final bool isLoading;
  final bool isShowAddMore;
  final void Function(Employee) onSelectEmployee;
  final void Function()? onAddMoreRecipients;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 16);
            },
            itemBuilder: (context, index) {
              if (isShowAddMore && index == 0) {
                return Column(children: [
                  const Expanded(
                    child: CircleAvatar(
                      child: Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SizedBox(
                      width: 78,
                      child: Text(
                        "Add more recipients",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ]);
              }

              return const Skeletonizer(
                child: Column(
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
                ),
              );
            },
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 4),
          scrollDirection: Axis.horizontal,
          itemCount:
              isShowAddMore ? listEmployees.length + 1 : listEmployees.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 4);
          },
          itemBuilder: (context, index) {
            if (isShowAddMore && index == 0) {
              return GestureDetector(
                onTap: () {
                  if (isShowAddMore && onAddMoreRecipients != null) {
                    onAddMoreRecipients!();
                  }
                },
                child: Column(children: [
                  const Expanded(
                    child: CircleAvatar(
                      child: Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SizedBox(
                      width: 78,
                      child: Text(
                        "Add more recipients",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ]),
              );
            }

            final user =
                isShowAddMore ? listEmployees[index - 1] : listEmployees[index];

            return GestureDetector(
              onTap: () {
                onSelectEmployee(user);
              },
              child: EmployeeItem(
                imageUrl: user.picture,
                name: user.name,
                wrapName: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
