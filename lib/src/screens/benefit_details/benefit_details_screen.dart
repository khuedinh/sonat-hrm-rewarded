import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/code_dialog.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class BenefitDetailScreen extends StatelessWidget {
  const BenefitDetailScreen({
    super.key,
    required this.benefit,
  });

  static const String routeName = '/benefit_detail';

  final Benefit benefit;

  void _handleShowCode(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const CodeDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      bottomNavigationBar: benefit.isClaimed!
          ? null
          : BottomAppBar(
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
              height: 280,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
              ),
              child: Image.network(
                benefit.image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              benefit.name,
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DisplayAmount(
                              amount: benefit.price,
                              icon: Icons.currency_bitcoin_rounded,
                              suffix: "coins",
                            ),
                          ],
                        ),
                      ),
                      if (benefit.isClaimed!)
                        SizedBox(
                          height: 28,
                          child: OutlinedButton(
                            onPressed: () {
                              _handleShowCode(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              side: BorderSide(
                                width: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            child: const Text('Show code'),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const HtmlWidget(
                    '<h3>Lorem ipsum dolor sit amet consectetuer adipiscing elit</h3><p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa <strong>strong</strong>. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede <a class="external ext" href="https://google.com">link</a> mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi.</p><h3>Lorem ipsum dolor sit amet consectetuer adipiscing elit</h3><h3>Aenean commodo ligula eget dolor aenean massa</h3><p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.</p>',
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
