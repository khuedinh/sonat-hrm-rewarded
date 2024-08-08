import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/screens/benefit_detail/benefit_detail_screen.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/code_dialog.dart';

class ClaimedBenefitItem extends StatelessWidget {
  const ClaimedBenefitItem({
    super.key,
    required this.benefit,
  });

  final Benefit benefit;

  void _handleShowCode(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CodeDialog(isUsed: benefit.isUsed!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.push(BenefitDetailScreen.routeName, extra: benefit);
        },
        borderRadius: BorderRadius.circular(8),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Image.network(
                  benefit.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit.name,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      benefit.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Claimed at: 2024/07/08 12:54"),
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
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                    child: const Text('Show code'),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
