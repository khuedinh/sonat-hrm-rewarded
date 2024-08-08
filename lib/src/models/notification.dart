class Notification {
  final String id;
  final String from;
  final String to;
  final String content;
  final DateTime createdAt;
  final bool? hasRead;

  const Notification({
    required this.id,
    required this.from,
    required this.to,
    required this.content,
    required this.createdAt,
    this.hasRead = false,
  });
}
