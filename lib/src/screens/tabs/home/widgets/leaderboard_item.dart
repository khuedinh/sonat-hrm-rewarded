import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/models/leaderboard.dart';

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({super.key, required this.index, required this.item});

  final LeaderboardData item;
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
        SizedBox(
          width: 36,
          height: 36,
          child: CircleAvatar(
            radius: 24,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: item.picture,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/default_avatar.png",
                  fit: BoxFit.cover,
                ), // Optional: Error widget
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.name,
          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          "${item.totalReceived} ${AppLocalizations.of(context)!.recognitions}",
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        )
      ]),
    );
  }
}
