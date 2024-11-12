part of "recognition_bloc.dart";

enum SortBy { latest, earliest }

enum TimeRange { last7Days, last30Days, last60Days }

// ignore: constant_identifier_names
enum RecognitionType { peer_to_peer, team, e_card }

class RecognitionState extends Equatable {
  const RecognitionState({
    this.isLoadingRecognitionHistory = true,
    this.isLoadingListEmployees = true,
    this.isLoadingRecognitionValues = true,
    this.isLoadingListGroups = true,
    this.sentHistory = const [],
    this.receivedHistory = const [],
    this.listEmployees = const [],
    this.listRecognitionValues = const [],
    this.listGroups = const [],
    this.sortBy,
    this.timeRange,
    this.type,
    this.startDate,
    this.endDate,
    this.searchEmployee = "",
  });

  final bool isLoadingRecognitionHistory;
  final bool isLoadingListEmployees;
  final bool isLoadingRecognitionValues;
  final bool isLoadingListGroups;
  final List<Recognition> sentHistory;
  final List<Recognition> receivedHistory;
  final List<Employee> listEmployees;
  final List<RecognitionValue> listRecognitionValues;
  final List<Group> listGroups;
  final SortBy? sortBy;
  final TimeRange? timeRange;
  final RecognitionType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchEmployee;

  RecognitionState copyWith({
    bool? isLoadingRecognitionHistory,
    bool? isLoadingListEmployees,
    bool? isLoadingRecognitionValues,
    bool? isLoadingListGroups,
    List<Recognition>? sentHistory,
    List<Recognition>? receivedHistory,
    List<Employee>? listEmployees,
    List<RecognitionValue>? listRecognitionValues,
    List<Group>? listGroups,
    SortBy? sortBy,
    TimeRange? timeRange,
    RecognitionType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? searchEmployee,
  }) {
    return RecognitionState(
      isLoadingRecognitionHistory:
          isLoadingRecognitionHistory ?? this.isLoadingRecognitionHistory,
      isLoadingListEmployees:
          isLoadingListEmployees ?? this.isLoadingListEmployees,
      isLoadingRecognitionValues:
          isLoadingRecognitionValues ?? this.isLoadingRecognitionValues,
      isLoadingListGroups: isLoadingListGroups ?? this.isLoadingListGroups,
      sentHistory: sentHistory ?? this.sentHistory,
      receivedHistory: receivedHistory ?? this.receivedHistory,
      listEmployees: listEmployees ?? this.listEmployees,
      listRecognitionValues:
          listRecognitionValues ?? this.listRecognitionValues,
      listGroups: listGroups ?? this.listGroups,
      sortBy: sortBy,
      timeRange: timeRange,
      type: type,
      startDate: startDate,
      endDate: endDate,
      searchEmployee: searchEmployee ?? this.searchEmployee,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingRecognitionHistory,
        isLoadingListEmployees,
        isLoadingRecognitionValues,
        isLoadingListGroups,
        sentHistory,
        receivedHistory,
        listEmployees,
        listRecognitionValues,
        listGroups,
        searchEmployee,
      ];
}
