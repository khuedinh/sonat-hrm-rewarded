part of "recognition_bloc.dart";

sealed class RecognitionEvent extends Equatable {}

class FetchRecognitionHistory extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}
