import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/success_screen.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/benefit.dart';
import 'package:sonat_hrm_rewarded/src/service/api/benefit_api.dart';
import 'package:sonat_hrm_rewarded/src/widgets/benefits/my_claim/code_dialog.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/loading_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class BenefitDetailsScreen extends StatefulWidget {
  const BenefitDetailsScreen({
    super.key,
    required this.benefit,
    this.claimedBenefit,
  });

  static const String routeName = '/benefit_details';

  final BenefitData benefit;
  final ClaimedBenefit? claimedBenefit;

  @override
  State<BenefitDetailsScreen> createState() => _BenefitDetailsScreenState();
}

class _BenefitDetailsScreenState extends State<BenefitDetailsScreen> {
  BenefitData? _benefitDetails;
  bool _isLoading = false;

  Future _handleGetBenefitDetails() async {
    final response =
        await BenefitApi.getBenefitDetails(benefitId: _benefitDetails!.id);

    setState(() {
      _benefitDetails = BenefitData.fromJson(response);
      _isLoading = false;
    });
  }

  void _handleShowCode(
      BuildContext context, ClaimedBenefit claimedBenefit) async {
    showDialog(
      context: context,
      builder: (context) {
        return CodeDialog(
          qrCode: claimedBenefit.qrCode,
          code: claimedBenefit.code,
        );
      },
    );
  }

  void _handleRedeemBenefit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    await BenefitApi.redeemBenefit(_benefitDetails!.id);

    if (!mounted) return;

    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SuccessScreen();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _benefitDetails = widget.benefit;
    _handleGetBenefitDetails();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "Benefit details"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: widget.claimedBenefit == null
          ? BottomAppBar(
              height: 64,
              color: theme.colorScheme.surface,
              child: FilledButton(
                onPressed: _handleRedeemBenefit,
                child: Text(
                  'Redeem now',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : null,
      body: RefreshableWidget(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          _handleGetBenefitDetails();
        },
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                  ),
                  child: _isLoading
                      ? const Skeletonizer(
                          child: Bone.square(
                          size: 500,
                        ))
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: 240,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            pauseAutoPlayOnTouch: true,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: _benefitDetails!.thumbnails.map((item) {
                            return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: item.imageUrl,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isLoading
                                    ? const Skeletonizer(
                                        child:
                                            Bone.text(words: 3, fontSize: 20),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _benefitDetails!.name,
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (widget.claimedBenefit != null)
                                            SizedBox(
                                              height: 28,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  _handleShowCode(
                                                    context,
                                                    widget.claimedBenefit!,
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  side: BorderSide(
                                                    width: 2,
                                                    color: theme
                                                        .colorScheme.primary,
                                                  ),
                                                ),
                                                child: const Text('Show code'),
                                              ),
                                            )
                                        ],
                                      ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _isLoading
                                        ? const Skeletonizer(
                                            child: Bone.text(
                                              words: 2,
                                              fontSize: 16,
                                            ),
                                          )
                                        : DisplayAmount(
                                            amount:
                                                _benefitDetails!.exchangePrice,
                                            icon:
                                                Icons.currency_bitcoin_rounded,
                                            suffix: "coins",
                                          ),
                                    _isLoading
                                        ? const Skeletonizer(
                                            child: Bone.text(
                                              words: 2,
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                            "Stock: ${_benefitDetails!.inStock}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _isLoading
                          ? SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  for (int i = 0; i < 10; i++)
                                    Skeletonizer(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: const Bone.text(words: 10),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : Text(_benefitDetails!.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
