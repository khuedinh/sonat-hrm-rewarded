import 'package:flutter/material.dart';

enum PriceFilter { descending, ascending }

enum NameFilter { aToZ, zToA }

class BenefitFilters extends StatefulWidget {
  const BenefitFilters({super.key});

  @override
  State<BenefitFilters> createState() => _BenefitFiltersState();
}

class _BenefitFiltersState extends State<BenefitFilters> {
  RangeValues _priceRange = const RangeValues(0, 15000);
  PriceFilter? _priceFilter;
  NameFilter? _nameFilter;

  void _handleResetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 15000);
      _priceFilter = null;
      _nameFilter = null;
    });
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
                    "Price range (${_priceRange.start.toInt().toString()} - ${_priceRange.end.toInt().toString()})",
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
                      values: _priceRange,
                      min: 0,
                      max: 15000,
                      divisions: 150,
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
                    children: PriceFilter.values.map((item) {
                      final label = item == PriceFilter.descending
                          ? "Descending"
                          : "Ascending";
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _priceFilter = item;
                                return;
                              }
                              _priceFilter = null;
                            });
                          },
                          selected: _priceFilter == item);
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
                    children: NameFilter.values.map((item) {
                      final label =
                          item == NameFilter.aToZ ? "A to Z" : "Z to A";
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _nameFilter = item;
                                return;
                              }
                              _nameFilter = null;
                            });
                          },
                          selected: _nameFilter == item);
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
                        Navigator.of(context).pop();
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
