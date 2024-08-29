import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _handleApplyFilter() {
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
                "Filters",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _handleResetFilters,
                style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                label: const Text("Reset"),
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
                    "Price range (${_priceRange!.start.toInt().toString()} - ${_priceRange!.end.toInt().toString()})",
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
                    "Price",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: SortPrice.values.map((item) {
                      final label = item == SortPrice.descending
                          ? "Descending"
                          : "Ascending";
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
                    "Name",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: SortName.values.map((item) {
                      final label = item == SortName.aToZ ? "A to Z" : "Z to A";
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
                      child: const Text("Discard"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        _handleApplyFilter();
                      },
                      child: const Text("Apply"),
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
