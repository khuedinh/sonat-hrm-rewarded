import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/benefits/bloc/benefits_bloc.dart';

class BenefitFilters extends StatefulWidget {
  const BenefitFilters({
    super.key,
    required this.defaultPriceRange,
    this.defaultSortPrice,
    this.defaultSortName,
  });

  final RangeValues defaultPriceRange;
  final SortPrice? defaultSortPrice;
  final SortName? defaultSortName;

  @override
  State<BenefitFilters> createState() => _BenefitFiltersState();
}

class _BenefitFiltersState extends State<BenefitFilters> {
  RangeValues? _priceRange;
  SortPrice? _sortPrice;
  SortName? _sortName;

  void _handleResetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 30000);
      _sortPrice = null;
      _sortName = null;
    });
  }

  void _handleApplyFilters() {
    context.read<BenefitsBloc>().add(ChangeFilter(
          priceRange: _priceRange,
          sortPrice: _sortPrice,
          sortName: _sortName,
        ));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _priceRange = widget.defaultPriceRange;
    _sortPrice = widget.defaultSortPrice;
    _sortName = widget.defaultSortName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.filters,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _handleResetFilters,
                style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                label: Text(AppLocalizations.of(context)!.reset),
                icon: const Icon(
                  Icons.restore_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.price_range} (${_priceRange!.start.toInt().toString()} - ${_priceRange!.end.toInt().toString()})",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                    ),
                    child: RangeSlider(
                      mouseCursor: WidgetStateMouseCursor.textable,
                      values: _priceRange!,
                      min: 0,
                      max: 30000,
                      divisions: 300,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.price,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: SortPrice.values.map((item) {
                      final label = item == SortPrice.descending
                          ? AppLocalizations.of(context)!.descending
                          : AppLocalizations.of(context)!.ascending;
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _sortPrice = item;
                                return;
                              }
                              _sortPrice = null;
                            });
                          },
                          selected: _sortPrice == item);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: SortName.values.map((item) {
                      final label = item == SortName.aToZ
                          ? AppLocalizations.of(context)!.a_to_z
                          : AppLocalizations.of(context)!.z_to_a;
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _sortName = item;
                                return;
                              }
                              _sortName = null;
                            });
                          },
                          selected: _sortName == item);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        side: BorderSide(
                          width: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.discard),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        _handleApplyFilters();
                      },
                      child: Text(AppLocalizations.of(context)!.apply),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
