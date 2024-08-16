class Recognition {
  final String id;
  final String name;
  final String? role;
  final String content;
  final DateTime createdAt;
  final bool? hasRead;
  final int quantity;

  const Recognition({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    this.hasRead = false,
    this.role = "",
    this.quantity = 0,
  });
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
