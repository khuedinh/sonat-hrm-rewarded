class Balance {
  final String id;
  final int currentPoint;
  final int currentCoin;
  final String employeeEmail;

  Balance({
    required this.id,
    required this.currentPoint,
    required this.currentCoin,
    required this.employeeEmail,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      id: json['id'],
      currentPoint: json['currentPoint'],
      currentCoin: json['currentCoin'],
      employeeEmail: json['employeeEmail'],
    );
  }
}
