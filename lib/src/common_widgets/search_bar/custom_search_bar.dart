import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar(
      {super.key, required this.searchController, this.borderRadius});
  final TextEditingController searchController;
  final BorderRadius? borderRadius;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: CupertinoSearchTextField(
        controller: widget.searchController,
        borderRadius: widget.borderRadius,
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        prefixIcon: const Icon(Icons.search),
        prefixInsets: const EdgeInsets.only(left: 10),
        suffixIcon: const Icon(Icons.clear),
        suffixInsets: const EdgeInsets.only(right: 10),
      ),
    );
  }
}
