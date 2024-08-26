import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/category.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({
    super.key,
    required this.listCategories,
    required this.selectedCategory,
    required this.handleSelectCategory,
  });

  final List listCategories;
  final String selectedCategory;
  final void Function(String category) handleSelectCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          scrollDirection: Axis.horizontal,
          itemCount: listCategories.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 8);
          },
          itemBuilder: (context, index) {
            final CategoryResponse category = listCategories[index];
            final isSelected = selectedCategory == category.id;

            return GestureDetector(
              onTap: () {
                handleSelectCategory(isSelected ? "" : category.id);
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl: category.imageUrl,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SizedBox(
                      width: 76,
                      child: Text(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        category.name,
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
