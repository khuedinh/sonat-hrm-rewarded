import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/models/category.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BenefitsBloc, BenefitsState>(builder: (context, state) {
      final listCategories = [
        CategoryData(
          id: "",
          name: "All",
          description: "",
          imageUrl: "assets/images/gift_all.jpg",
        ),
        ...state.listCategories
      ];
      final selectedCategory = state.selectedCategory;
      final isLoadingCategories = state.isLoadingCategories;

      if (isLoadingCategories) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 90,
            child: Skeletonizer(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 16);
                },
                itemBuilder: (context, index) {
                  return const Column(
                    children: [
                      Expanded(
                        child: Bone.circle(size: 36),
                      ),
                      SizedBox(height: 4),
                      Expanded(
                        child: SizedBox(
                          width: 70,
                          child: Bone.text(words: 2, fontSize: 11),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      }

      return SliverToBoxAdapter(
        child: SizedBox(
          height: 78,
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 4),
            scrollDirection: Axis.horizontal,
            itemCount: listCategories.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 4);
            },
            itemBuilder: (context, index) {
              final CategoryData category = listCategories[index];
              final isSelected = selectedCategory == category.id;

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    context.read<BenefitsBloc>().add(
                          SelectCategory(categoryId: ""),
                        );
                    return;
                  }
                  context.read<BenefitsBloc>().add(
                        SelectCategory(categoryId: category.id),
                      );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: category.imageUrl.contains("https")
                            ? CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset(
                                category.imageUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
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
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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
    });
  }
}
