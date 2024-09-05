class Leaderboard {
  final String name;
  final int coin;
  final String? avatar;

  const Leaderboard({required this.name, required this.coin, this.avatar});
}

class LeaderboardData {
  String userId;
  String name;
  String picture;
  String position;
  String department;
  int totalReceived;

  LeaderboardData(
      {required this.userId,
      required this.name,
      required this.picture,
      required this.position,
      required this.department,
      required this.totalReceived});

  LeaderboardData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        picture = json['picture'],
        position = json['position'],
        department = json['department'],
        totalReceived = json['totalReceived'];
}
