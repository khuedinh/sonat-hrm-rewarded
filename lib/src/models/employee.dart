// class Profile {
//   final String id;
//   final String phone;
//   final String address;
//   final String hometown;
//   final String birthday;
//   final String startTime;
//   final String endTime;
//   final String gender;
//   final String school;

// }
class Team {
  final String id;
  final String name;

  const Team({
    required this.id,
    required this.name,
  });
}

class Position {
  final String id;
  final String name;
  final Team team;

  const Position({
    required this.id,
    required this.name,
    required this.team,
  });
}

class Employee {
  final String id;
  final String name;
  final String email;
  final String picture;
  final String? positionId;
  //final Position? position;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    this.positionId,
    //required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      picture: json['picture'],
      positionId: json['positionId'] as String?,
      // position: Position(
      //   id: json['position']['id'],
      //   name: json['position']['name'],
      //   team: Team(
      //     id: json['position']['team']['id'],
      //     name: json['position']['team']['name'],
      //   ),
      // ) as Position?,
    );
  }
}

class Group {
  String id;
  String name;

  Group({
    required this.id,
    required this.name,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
    );
  }
}

class MemberGroup {
  String id;
  Employee employee;

  MemberGroup({
    required this.id,
    required this.employee,
  });

  factory MemberGroup.fromJson(Map<String, dynamic> json) {
    return MemberGroup(
      id: json['id'],
      employee: Employee.fromJson(json['employees']),
    );
  }
}

class GroupDetails {
  String id;
  String name;
  List<MemberGroup> memberGroups;

  GroupDetails({
    required this.id,
    required this.name,
    required this.memberGroups,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      id: json['id'],
      name: json['name'],
      memberGroups: (json['memberGroups'] as List)
          .map((item) => MemberGroup.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
