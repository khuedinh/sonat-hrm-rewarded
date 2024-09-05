part of "recognition_bloc.dart";

sealed class RecognitionEvent extends Equatable {}

class FetchRecognitionHistory extends RecognitionEvent {
  @override
  List<Object?> get props => [];
}

class FilterRecognitionHistory extends RecognitionEvent {
  final SortByFilter sortByFilter;
  final TimeFilter timeFilter;
  final TypeFilter typeFilter;

  FilterRecognitionHistory({
    required this.sortByFilter,
    required this.timeFilter,
    required this.typeFilter,
  });

  @override
  List<Object?> get props => [sortByFilter, timeFilter, typeFilter];
}
