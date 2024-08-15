class TransactionHistory {
  final String id;
  final String content;
  final int previousBalance;
  final int currentBalance;
  final DateTime createdAt;

  const TransactionHistory({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.currentBalance,
    required this.previousBalance,
  });
}
