import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/benefit.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_archived_box/benefit_archived_box_screen.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/list/list_claimed_benefits.dart';

class MyClaimTab extends StatefulWidget {
  const MyClaimTab({super.key});

  @override
  State<MyClaimTab> createState() => _MyClaimTabState();
}

class _MyClaimTabState extends State<MyClaimTab> {
  final List<Benefit> listClaimedBenefits = [];

  void _handleArchiveBenefit(Benefit benefit, int index) {
    setState(() {
      listClaimedBenefits.remove(benefit);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Archieved successfully!"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              listClaimedBenefits.insert(
                index,
                benefit,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    listClaimedBenefits.addAll(
      listBenefits
          .where(
            (benefit) => benefit.isFeatured!,
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ready-to-use benefits",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  context.push(BenefitArchivedBoxScreen.routeName);
                },
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(8),
                  ),
                ),
                label: const Text("Archived box"),
                icon: const Icon(Icons.archive_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListClaimedBenefits(
            isDismissible: true,
            listClaimedBenefits: listClaimedBenefits,
            handleArchiveBenefit: _handleArchiveBenefit,
          ),
        ],
      ),
    );
  }
}
