part of "recognition_bloc.dart";

class RecognitionState extends Equatable {
  const RecognitionState({
    this.isLoadingRecognitionHistory = true,
    this.sentHistory = const [],
    this.receivedHistory = const [],
  });

  final bool isLoadingRecognitionHistory;
  final List<Recognition> sentHistory;
  final List<Recognition> receivedHistory;

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
