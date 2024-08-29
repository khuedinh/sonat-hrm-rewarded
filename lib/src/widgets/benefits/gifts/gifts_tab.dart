import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_benefits_grid.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/list/list_categories.dart';

class GiftsTab extends StatefulWidget {
  const GiftsTab({super.key});

  @override
  State<GiftsTab> createState() => _GiftsTabState();
}

class _GiftsTabState extends State<GiftsTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BenefitsBloc>(context).add(InitBenefitsData());
    BlocProvider.of<BenefitsBloc>(context).add(InitCategoriesData());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshableWidget(
          onRefresh: () async {
            context.read<BenefitsBloc>().add(InitCurrentBalance());
            context.read<BenefitsBloc>().add(InitBenefitsData());
          },
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            BlocBuilder<BenefitsBloc, BenefitsState>(
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'What are you looking for?',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      prefixIcon: Icon(Icons.search, size: 28),
                      border: OutlineInputBorder(
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
