import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/list/list_benefits_grid.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/widgets/list/list_categories.dart';

class GiftsTab extends StatefulWidget {
  const GiftsTab({super.key});

  @override
  State<GiftsTab> createState() => _GiftsTabState();
}

class _GiftsTabState extends State<GiftsTab>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    BlocProvider.of<BenefitsBloc>(context).add(InitBenefitsData());
    BlocProvider.of<BenefitsBloc>(context).add(InitCategoriesData());
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<BenefitsBloc>().add(LoadMoreBenefits());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshableWidget(
          controller: _scrollController,
          onRefresh: () async {
            context.read<BenefitsBloc>().add(RefreshBenefitsData());
          },
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            BlocBuilder<BenefitsBloc, BenefitsState>(
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .what_are_you_looking_for,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 28),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<BenefitsBloc>().add(
                            ChangeTextSearch(text: value),
                          );
                    },
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const ListCategories(),
            const ListBenefitsGrid(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ]),
    );
  }
}
