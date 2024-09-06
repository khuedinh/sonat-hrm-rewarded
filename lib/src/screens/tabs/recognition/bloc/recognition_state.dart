part of "recognition_bloc.dart";

enum SortBy { latest, earliest }

enum TimeRange { last7Days, last30Days, last60Days }

// ignore: constant_identifier_names
enum RecognitionType { peer_to_peer, team, e_card }

class RecognitionState extends Equatable {
  const RecognitionState({
    this.isLoadingRecognitionHistory = true,
    this.sentHistory = const [],
    this.receivedHistory = const [],
    this.sortBy,
    this.timeRange,
    this.type,
    this.startDate,
    this.endDate,
  });

  final bool isLoadingRecognitionHistory;
  final List<Recognition> sentHistory;
  final List<Recognition> receivedHistory;
  final SortBy? sortBy;
  final TimeRange? timeRange;
  final RecognitionType? type;
  final DateTime? startDate;
  final DateTime? endDate;

  RecognitionState copyWith({
    bool? isLoadingRecognitionHistory,
    List<Recognition>? sentHistory,
    List<Recognition>? receivedHistory,
    SortBy? sortBy,
    TimeRange? timeRange,
    RecognitionType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return RecognitionState(
      isLoadingRecognitionHistory:
          isLoadingRecognitionHistory ?? this.isLoadingRecognitionHistory,
      sentHistory: sentHistory ?? this.sentHistory,
      receivedHistory: receivedHistory ?? this.receivedHistory,
      sortBy: sortBy,
      timeRange: timeRange,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  List<Object?> get props =>
      [isLoadingRecognitionHistory, sentHistory, receivedHistory];
}
