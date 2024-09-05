part of "recognition_bloc.dart";

class RecognitionState extends Equatable {
  const RecognitionState({
    this.isLoadingRecognitionHistory = true,
    this.sentHistory = const [],
    this.receivedHistory = const [],
    this.sortByFilter,
    this.timeFilter,
    this.typeFilter,
  });

  final bool isLoadingRecognitionHistory;
  final List<Recognition> sentHistory;
  final List<Recognition> receivedHistory;
  final SortByFilter? sortByFilter;
  final TimeFilter? timeFilter;
  final TypeFilter? typeFilter;

  RecognitionState copyWith({
    bool? isLoadingRecognitionHistory,
    List<Recognition>? sentHistory,
    List<Recognition>? receivedHistory,
  }) {
    return RecognitionState(
      isLoadingRecognitionHistory:
          isLoadingRecognitionHistory ?? this.isLoadingRecognitionHistory,
      sentHistory: sentHistory ?? this.sentHistory,
      receivedHistory: receivedHistory ?? this.receivedHistory,
    );
  }

  @override
  List<Object?> get props =>
      [isLoadingRecognitionHistory, sentHistory, receivedHistory];
}
