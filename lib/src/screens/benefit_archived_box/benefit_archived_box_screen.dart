import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/list/list_claimed_benefits.dart';

class BenefitArchivedBoxScreen extends StatelessWidget {
  const BenefitArchivedBoxScreen({super.key});

  static const routeName = '/benefit-archived-box';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "Achieved box"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            ListClaimedBenefits(
              isDismissible: false,
              listClaimedBenefits: listBenefits
                  .where((benefit) => benefit.isClaimed! && benefit.isUsed!)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
