import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class BenefitDetailScreen extends StatelessWidget {
  const BenefitDetailScreen({
    super.key,
    required this.benefit,
  });

  static const String routeName = '/benefit_detail';

  final Benefit benefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(benefit.name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "Benefit details"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        height: 64,
        color: theme.colorScheme.surface,
        child: FilledButton(
          onPressed: () {},
          child: Text(
            'Redeem now',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
              ),
              child: Image.network(
                benefit.image,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 268,
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                benefit.name,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              DisplayAmount(
                amount: benefit.price,
                icon: Icons.currency_bitcoin_rounded,
                suffix: "coins",
                textColor: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(benefit.description),
            ])
          ],
        ),
      ),
    );
  }
}
