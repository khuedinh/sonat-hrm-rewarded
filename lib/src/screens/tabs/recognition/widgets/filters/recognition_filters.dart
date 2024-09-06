import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/utils/date_time.dart';

class RecognitionFilters extends StatefulWidget {
  final SortBy? initSortBy;
  final TimeRange? initTimeRange;
  final RecognitionType? initType;
  final DateTime? initStartDate;
  final DateTime? initEndDate;

  const RecognitionFilters({
    super.key,
    this.initSortBy,
    this.initTimeRange,
    this.initType,
    this.initEndDate,
    this.initStartDate,
  });

  @override
  State<RecognitionFilters> createState() => _RecognitionFiltersState();
}

class _RecognitionFiltersState extends State<RecognitionFilters> {
  SortBy? _sortBy;
  TimeRange? _timeRange;
  RecognitionType? _type;
  DateTime? _startDate;
  DateTime? _endDate;

  void _handleSelectDateRange() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, 1, 1);

    final selectedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _startDate ?? firstDate,
        end: _endDate ?? now,
      ),
      firstDate: firstDate,
      lastDate: now,
    );

    if (selectedDate == null) return null;

    final diff = selectedDate.end.difference(
      selectedDate.start,
    );

    final diffEndDate = DateTime.now().difference(
      selectedDate.end,
    );

    setState(() {
      _startDate = selectedDate.start;
      _endDate = selectedDate.end;

      if (diffEndDate.inDays == 1) {
        switch (diff.inDays + 1) {
          case 7:
            _timeRange = TimeRange.last7Days;
            break;
          case 30:
            _timeRange = TimeRange.last30Days;
            break;
          case 60:
            _timeRange = TimeRange.last60Days;
        }
      }
    });
  }

  void _handleResetFilters() {
    setState(() {
      _timeRange = null;
      _sortBy = null;
      _type = null;
      _startDate = null;
      _endDate = null;
    });
  }

  void _handleApplyFilters() {
    context.read<RecognitionBloc>().add(FilterRecognitionHistory(
          type: _type,
          sortBy: _sortBy,
          timeRange: _timeRange,
          startDate: _startDate,
          endDate: _endDate,
        ));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initSortBy;
    _timeRange = widget.initTimeRange;
    _type = widget.initType;
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
                    children: RecognitionType.values.map((item) {
                      String label = "P2P";
                      switch (item) {
                        case RecognitionType.peer_to_peer:
                          label = "P2P";
                          break;
                        case RecognitionType.team:
                          label = "Team";
                          break;
                        case RecognitionType.e_card:
                          label = "E-Card";
                          break;
                      }

                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _type = item;
                                return;
                              }
                              _type = null;
                            });
                          },
                          selected: _type == item);
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
                    children: SortBy.values.map((item) {
                      final label =
                          item == SortBy.latest ? "Latest" : "Earliest";
                      return FilterChip(
                        label: Text(label),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _sortBy = item;
                              return;
                            }
                            _sortBy = null;
                          });
                        },
                        selected: _sortBy == item,
                      );
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
                    children: TimeRange.values.map((item) {
                      String label = "P2P";
                      switch (item) {
                        case TimeRange.last7Days:
                          label = "Last 7 days";
                          break;
                        case TimeRange.last30Days:
                          label = "Last 30 days";
                          break;
                        case TimeRange.last60Days:
                          label = "Last 60 days";
                          break;
                      }

                      return FilterChip(
                          label: Text(label),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _timeRange = item;
                                _endDate = DateTime.now()
                                    .subtract(const Duration(days: 1));
                                switch (item) {
                                  case TimeRange.last7Days:
                                    _startDate = DateTime.now().subtract(
                                      const Duration(days: 7),
                                    );

                                    break;
                                  case TimeRange.last30Days:
                                    _startDate = DateTime.now().subtract(
                                      const Duration(days: 30),
                                    );

                                    break;
                                  case TimeRange.last60Days:
                                    _startDate = DateTime.now().subtract(
                                      const Duration(days: 60),
                                    );
                                    break;
                                }
                                return;
                              }
                              _timeRange = null;
                            });
                          },
                          selected: _timeRange == item);
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
                        _handleApplyFilters();
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
