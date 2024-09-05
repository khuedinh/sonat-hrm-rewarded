import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';

part 'recognition_event.dart';
part 'recognition_state.dart';

class RecognitionBloc extends Bloc<RecognitionEvent, RecognitionState> {
  RecognitionBloc() : super(const RecognitionState()) {
    on<FetchRecognitionHistory>((RecognitionEvent event, Emitter emit) async {
      emit(state.copyWith(isLoadingRecognitionHistory: true));

      final response = await RecognitionApi.getHistory();

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
  }
}
