import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EmployeeItem extends StatelessWidget {
  const EmployeeItem({
    super.key,
    required this.imageUrl,
    required this.name,
    this.wrapName = false,
  });

  final String imageUrl;
  final String name;
  final bool wrapName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(children: [
      Expanded(
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/default_avatar.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
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
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    ]);
  }
}
