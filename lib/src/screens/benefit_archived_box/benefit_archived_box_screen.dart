import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/service/api/benefit_api.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/list/claimed_benefit_item.dart';

class BenefitArchivedBoxScreen extends StatefulWidget {
  const BenefitArchivedBoxScreen({super.key});

  static const routeName = '/benefit-archived-box';

  @override
  State<BenefitArchivedBoxScreen> createState() =>
      _BenefitArchivedBoxScreenState();
}

class _BenefitArchivedBoxScreenState extends State<BenefitArchivedBoxScreen> {
  List<ClaimedBenefit> _listArchiveBenefits = [];
  bool _isLoading = true;

  Future _handleGetListArchiveBenefits() async {
    setState(() {
      _isLoading = true;
    });

    final response = await BenefitApi.getListClaimedBenefits();
    final myClaimData = MyClaimResponse.fromJson(response);

    setState(() {
      _listArchiveBenefits = myClaimData.archivedBox;
      _isLoading = false;
    });
  }

  Future _handleRestoreBenefit(ClaimedBenefit claimedBenefit) async {
    final int index = _listArchiveBenefits.indexOf(claimedBenefit);
    setState(() {
      _listArchiveBenefits.remove(claimedBenefit);
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Restored successfully!"),
      duration: Duration(seconds: 2),
    ));

    final response =
        await BenefitApi.toggleArchiveBenefit(claimedBenefit.id, "restore");

    if (!response['success']) {
      setState(() {
        _listArchiveBenefits.insert(index, claimedBenefit);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleGetListArchiveBenefits();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "Achieved box"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: RefreshableWidget(
        onRefresh: () async {
          await _handleGetListArchiveBenefits();
        },
        slivers: [
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return const Skeletonizer(
                      child: Card(
                        child: ListTile(
                          leading: Bone.square(size: 76),
                          title: Bone.text(words: 2),
                          subtitle: Bone.text(
                            words: 5,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 8,
                ),
              ),
            ),
          if (_listArchiveBenefits.isEmpty)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_off),
                    SizedBox(height: 4),
                    Text("No data found."),
                  ],
                ),
              ),
            ),
          if (_listArchiveBenefits.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: _listArchiveBenefits.length,
                itemBuilder: (context, index) {
                  final ClaimedBenefit archivedBenefit =
                      _listArchiveBenefits[index];

                  return ClaimedBenefitItem(
                    claimedBenefit: archivedBenefit,
                    isArchived: true,
                    handleRestoreBenefit: _handleRestoreBenefit,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
