import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/benefit.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';

class MyClaimTab extends StatelessWidget {
  const MyClaimTab({super.key});

  void _handleShowCode(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            'Your code',
          ),
          content: Text('1234567890'),
        );
      },
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
                onPressed: () {},
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
          ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listBenefits.length,
            itemBuilder: (context, index) {
              final Benefit benefit = listBenefits[index];
              return Card(
                margin: EdgeInsets.zero,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        context.push('/benefit/${benefit.id}');
                      },
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: Image.network(
                                benefit.image,
                                width: 76,
                                height: 76,
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
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
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
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
