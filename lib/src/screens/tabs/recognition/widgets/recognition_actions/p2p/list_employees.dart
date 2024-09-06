import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/employee_item.dart';

class ListEmployees extends StatelessWidget {
  const ListEmployees({
    super.key,
    required this.isLoading,
    required this.listEmployees,
    required this.onSelectEmployee,
  });

  final List<Employee> listEmployees;
  final bool isLoading;
  final void Function(Employee) onSelectEmployee;

  @override
  Widget build(BuildContext context) {
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

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 4),
          scrollDirection: Axis.horizontal,
          itemCount: listEmployees.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 4);
          },
          itemBuilder: (context, index) {
            final user = listEmployees[index];

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
