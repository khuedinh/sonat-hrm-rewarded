import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/utils/date_time.dart';

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
  DateTime? _startDate;
  DateTime? _endDate;

  Future<DateTime?> _handleSelectDateRange() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final selectedDate = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    if (selectedDate == null) return null;

    setState(() {
      _startDate = selectedDate.start;
      _endDate = selectedDate.end;
    });
  }

  void _handleResetFilters() {
    setState(() {
      _timeFilter = null;
      _sortByFilter = null;
      _typeFilter = null;
    });
  }

  void _handleApplyFilters() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _sortByFilter = widget.initialSortByFilter;
    _timeFilter = widget.initialTimeFilter;
    _typeFilter = widget.initialTypeFilter;
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
                      String label = "P2P";
                      switch (item) {
                        case TypeFilter.p2p:
                          label = "P2P";
                          break;
                        case TypeFilter.team:
                          label = "Team";
                          break;
                        case TypeFilter.eCard:
                          label = "E-Card";
                          break;
                      }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Time",
                        style: theme.textTheme.titleMedium,
                      ),
                      TextButton.icon(
                          onPressed: _handleSelectDateRange,
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: Text(_startDate != null && _endDate != null
                              ? "${formatDate(_startDate!, format: "dd/MM/yyyy")} - ${formatDate(_endDate!, format: "dd/MM/yyyy")}"
                              : "Select date range"))
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: TimeFilter.values.map((item) {
                      String label = "P2P";
                      switch (item) {
                        case TimeFilter.allTime:
                          label = "Last 7 days";
                          break;
                        case TimeFilter.last7Days:
                          label = "Last 7 days";
                          break;
                        case TimeFilter.last30Days:
                          label = "Last 30 days";
                          break;
                        case TimeFilter.last60Days:
                          label = "Last 60 days";
                          break;
                      }

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
