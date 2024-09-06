import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';
import 'package:sonat_hrm_rewarded/src/utils/date_time.dart';

part 'recognition_event.dart';
part 'recognition_state.dart';

class RecognitionBloc extends Bloc<RecognitionEvent, RecognitionState> {
  RecognitionBloc() : super(const RecognitionState()) {
    on<FetchRecognitionHistory>((event, emit) async {
      emit(state.copyWith(isLoadingRecognitionHistory: true));

      final response = await RecognitionApi.getHistory(<String, dynamic>{});

      if (response != null) {
        emit(
          state.copyWith(
            isLoadingRecognitionHistory: false,
            sentHistory: (response['sent'] as List)
                .map((item) =>
                    Recognition.fromJson(item as Map<String, dynamic>))
                .toList(),
            receivedHistory: (response['received'] as List)
                .map((item) =>
                    Recognition.fromJson(item as Map<String, dynamic>))
                .toList(),
          ),
        );
        return;
      }

      emit(state.copyWith(
        isLoadingRecognitionHistory: false,
      ));
    });

    on<FilterRecognitionHistory>((event, emit) async {
      emit(state.copyWith(
        isLoadingRecognitionHistory: true,
        type: event.type,
        sortBy: event.sortBy,
        timeRange: event.timeRange,
        startDate: event.startDate,
        endDate: event.endDate,
      ));

      final response = await RecognitionApi.getHistory({
        "type": event.type?.toString().split('.').last,
        "sortBy": event.sortBy?.toString().split('.').last,
        "startDate": event.startDate != null
            ? formatDate(event.startDate!, format: "yyyy-MM-dd")
            : null,
        "endDate": event.endDate != null
            ? formatDate(event.endDate!, format: "yyyy-MM-dd")
            : null,
      });

      if (response != null) {
        emit(
          state.copyWith(
            isLoadingRecognitionHistory: false,
            sentHistory: (response['sent'] as List)
                .map((item) =>
                    Recognition.fromJson(item as Map<String, dynamic>))
                .toList(),
            receivedHistory: (response['received'] as List)
                .map((item) =>
                    Recognition.fromJson(item as Map<String, dynamic>))
                .toList(),
            type: event.type,
            sortBy: event.sortBy,
            timeRange: event.timeRange,
            startDate: event.startDate,
            endDate: event.endDate,
          ),
        );
        return;
      }

      emit(state.copyWith(
        isLoadingRecognitionHistory: false,
        type: event.type,
        sortBy: event.sortBy,
        timeRange: event.timeRange,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    });
  }
}
