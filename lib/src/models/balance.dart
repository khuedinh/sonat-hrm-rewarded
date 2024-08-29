class CurrentBalance {
  final String id;
  final int currentPoint;
  final int currentCoin;
  final String employeeEmail;

  CurrentBalance({
    required this.id,
    required this.currentPoint,
    required this.currentCoin,
    required this.employeeEmail,
  });

  factory CurrentBalance.fromJson(Map<String, dynamic> json) {
    return CurrentBalance(
      id: json['id'],
      currentPoint: json['currentPoint'],
      currentCoin: json['currentCoin'],
      employeeEmail: json['employeeEmail'],
    );
  }
}
