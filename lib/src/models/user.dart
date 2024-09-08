class UserInfo {
  String id;
  String email;
  String name;
  String? picture;
  String? positionId;
  Position position;
  Balance balance;
  UserRecognition userRecognition;
  int activeBenefit;

  UserInfo({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
    required this.positionId,
    required this.position,
    required this.balance,
    required this.userRecognition,
    required this.activeBenefit,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        picture = json['picture'],
        positionId = json['positionId'],
        position = Position.fromJson(json['position']),
        balance = Balance.fromJson(json['balance']),
        userRecognition = UserRecognition.fromJson(json['userRecognition']),
        activeBenefit = json['activeBenefit'] ?? 0;
}

class Position {
  String id;
  String name;
  Team team;

  Position({required this.id, required this.name, required this.team});

  Position.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        team = Team.fromJson(json['team']);
}

class Team {
  String id;
  String name;

  Team({required this.id, required this.name});

  Team.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Balance {
  String id;
  int currentPoint;
  int currentCoin;
  String employeeEmail;

  Balance({
    required this.id,
    required this.currentPoint,
    required this.currentCoin,
    required this.employeeEmail,
  });

  Balance.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        currentPoint = json['currentPoint'] ?? 0,
        currentCoin = json['currentCoin'] ?? 0,
        employeeEmail = json['employeeEmail'] ?? "";
}

class UserRecognition {
  String id;
  int totalSent;
  int totalReceive;
  String employeeEmail;
  int totalRecognition;

  UserRecognition({
    required this.id,
    required this.totalSent,
    required this.totalReceive,
    required this.employeeEmail,
    required this.totalRecognition,
  });

  UserRecognition.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        totalSent = json['totalSent'] ?? 0,
        totalReceive = json['totalReceive'] ?? 0,
        employeeEmail = json['employeeEmail'],
        totalRecognition = json['totalRecognition'] ?? 0;
}
