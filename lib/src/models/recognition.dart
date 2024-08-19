class Recognition {
  final String id;
  final String name;
  final String content;
  final DateTime createdAt;
  final int amount;
  final String? recognitionValueId;
  final String? message;
  final String? imageUrl;
  final String? cardContent;
  final String? type;

  const Recognition({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.amount,
    required this.type,
    this.recognitionValueId,
    this.message,
    this.imageUrl,
    this.cardContent,
    
  });

  factory Recognition.fromJson(Map<String, dynamic> json) {
    return Recognition(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      recognitionValueId: json['recognitionValueId'],
      message: json['message'],
      imageUrl: json['imageUrl'],
      cardContent: json['cardContent'],
      content: json['content'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
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
      sent: (json['sent'] as List<Recognition>)
          .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
          .toList(),
      received: (json['received'] as List<Recognition>)
          .map((item) => Recognition.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RecognitionValue {
  final String id;
  final String name;
  final dynamic icon;

  const RecognitionValue({
    required this.id,
    required this.name,
    required this.icon,
  });
}
