import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({super.key, required this.index, required this.item});

  final dynamic item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(children: [
        Text(
          "${index + 1}",
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(
            Icons.person,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item["name"],
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          "${item["coins"]} coins",
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        )
      ]),
    );
  }
}
