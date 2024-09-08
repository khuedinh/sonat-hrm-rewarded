import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({
    super.key,
    required this.name,
    this.isSelected = false,
    this.wrapName = false,
  });

  final String name;
  final bool isSelected;
  final bool wrapName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(children: [
      const Expanded(
        child: CircleAvatar(
          child: Icon(Icons.group),
        ),
      ),
      const SizedBox(height: 4),
      Expanded(
        child: SizedBox(
          width: wrapName ? 78 : 150,
          child: Text(
            name,
            maxLines: 2,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
        ),
      ),
    ]);
  }
}
