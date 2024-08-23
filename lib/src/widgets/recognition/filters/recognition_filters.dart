import 'package:flutter/material.dart';

enum SortByFilter { latest, earliest }

enum TimeFilter { last7Days, last30Days, last60Days, allTime }

enum TypeFilter { all, p2p, team, eCard, award }

class RecognitionFilters extends StatefulWidget {
  final SortByFilter? initialSortByFilter;
  final TimeFilter? initialTimeFilter;
  final TypeFilter? initialTypeFilter;

  const RecognitionFilters({
    super.key,
    this.initialSortByFilter,
    this.initialTimeFilter,
    this.initialTypeFilter,
  });

  @override
  State<RecognitionFilters> createState() => _RecognitionFiltersState();
}

class _RecognitionFiltersState extends State<RecognitionFilters> {
  SortByFilter? _sortByFilter;
  TimeFilter? _timeFilter;
  TypeFilter? _typeFilter;

  @override
  void initState() {
    super.initState();
    _sortByFilter = widget.initialSortByFilter;
    _timeFilter = widget.initialTimeFilter;
    _typeFilter = widget.initialTypeFilter;
  }

  void _handleResetFilters() {
    setState(() {
      _timeFilter = null;
      _sortByFilter = null;
      _typeFilter = null;
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
                    "Type",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: TypeFilter.values.map((item) {
                      final label = item == TypeFilter.all
                          ? "All"
                          : item == TypeFilter.p2p
                              ? "P2P"
                              : item == TypeFilter.team
                                  ? "Team"
                                  : item == TypeFilter.eCard
                                      ? "E-Card"
                                      : "Award";
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _typeFilter = item;
                                return;
                              }
                              _typeFilter = null;
                            });
                          },
                          selected: _typeFilter == item);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sort by",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: SortByFilter.values.map((item) {
                      final label =
                          item == SortByFilter.latest ? "Latest" : "Earliest";
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _sortByFilter = item;
                                return;
                              }
                              _sortByFilter = null;
                            });
                          },
                          selected: _sortByFilter == item);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: TimeFilter.values.map((item) {
                      final label = item == TimeFilter.allTime
                          ? "All time"
                          : item == TimeFilter.last7Days
                              ? "Last 7 days"
                              : item == TimeFilter.last30Days
                                  ? "Last 30 days"
                                  : "Last 60 days";
                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _timeFilter = item;
                                return;
                              }
                              _timeFilter = null;
                            });
                          },
                          selected: _timeFilter == item);
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
                          color: theme.colorScheme.primaryContainer,
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
