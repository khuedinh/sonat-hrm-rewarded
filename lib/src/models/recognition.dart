import 'package:sonat_hrm_rewarded/src/models/employee.dart';

class DetailRecognitions {
  final String id;
  final Employee employee;

  DetailRecognitions({
    required this.id,
    required this.employee,
  });

  factory DetailRecognitions.fromJson(Map<String, dynamic> json) {
    return DetailRecognitions(
      id: json['id'],
      employee: Employee.fromJson(json['employee']),
    );
  }
}

class Recognition {
  final String id;
  final String? content;
  //final DateTime createdAt;
  final int amount;
  final String? recognitionValueId;
  final String? message;
  final String? imageUrl;
  final String? cardContent;
  final String? type;
  final List<DetailRecognitions>? detailRecognitions;
  final Employee employee;

  const Recognition({
    required this.id,
    required this.content,
    required this.amount,
    required this.type,
    this.recognitionValueId,
    this.message,
    this.imageUrl,
    this.cardContent,
    this.detailRecognitions,
    required this.employee,
  });

  factory Recognition.fromJson(Map<String, dynamic> json) {
    return Recognition(
      id: json['id'],
      amount: json['amount'],
      recognitionValueId: json['recognitionValueId'],
      message: json['message'] as String?,
      imageUrl: json['imageUrl'] as String?,
      cardContent: json['cardContent'] as String?,
      content: json['content'] as String?,
      type: json['type'],
      detailRecognitions: json['detailRecognitions'] != null
          ? (json['detailRecognitions'] as List)
              .map((item) =>
                  DetailRecognitions.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      employee: Employee.fromJson(json['employee']),
    );
  }
}

class RecognitionHistory {
  final List<Recognition> sent;
  final List<Recognition> received;

  RecognitionHistory({
    required this.sent,
    required this.received,
  });

  factory RecognitionHistory.fromJson(Map<String, dynamic> json) {
    print('json: $json');
    return RecognitionHistory(
      sent: (json['sent'] as List)
          .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
          .toList(),
      received: (json['received'] as List)
          .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RecognitionValueChildren {
  final String id;
  final String name;

  const RecognitionValueChildren({
    required this.id,
    required this.name,
  });

  factory RecognitionValueChildren.fromJson(Map<String, dynamic> json) {
    return RecognitionValueChildren(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RecognitionValue {
  final String id;
  final String name;
  final List<RecognitionValueChildren> recognitionValues;

  const RecognitionValue({
    required this.id,
    required this.name,
    required this.recognitionValues,
  });

  factory RecognitionValue.fromJson(Map<String, dynamic> json) {
    return RecognitionValue(
      id: json['id'],
      name: json['name'] as String,
      recognitionValues: (json['recognitionValues'] as List)
          .map((item) =>
              RecognitionValueChildren.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
