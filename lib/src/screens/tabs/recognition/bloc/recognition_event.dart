part of "recognition_bloc.dart";

sealed class RecognitionEvent extends Equatable {}

class FetchRecognitionHistory extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}

class FilterRecognitionHistory extends RecognitionEvent {
  final RecognitionType? type;
  final SortBy? sortBy;
  final TimeRange? timeRange;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterRecognitionHistory({
    this.type,
    this.sortBy,
    this.timeRange,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [sortBy, timeRange, type, startDate, endDate];
}

class FetchListRecipients extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}

class FetchListRecognitionValues extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}

class FetchListGroups extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}
