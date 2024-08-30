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
 // String name;
  Employee employees;

  MemberGroup({
    required this.id,
  //  required this.name,
    required this.employees,
  });

  factory MemberGroup.fromJson(Map<String, dynamic> json) {
    return MemberGroup(
      id: json['id'],
     // name: json['name'],
      employees: Employee.fromJson(json['employees']),
    );
  }
}

// {id: c8128974-e994-4f87-959c-770129e68e83, createdAt: 2024-08-27T10:41:28.165Z, updatedAt: 2024-08-27T10:41:28.165Z, 
// deletedAt: null, employeeEmail: maivl@sonat.vn, employees: 
// {id: 5b406f45-bfe3-4fc7-a526-ab22e6eea4e0, createdAt: 2023-10-24T02:22:42.532Z, updatedAt: 2023-11-10T06:06:55.977Z, 
// deletedAt: null, email: maivl@sonat.vn, name: Vũ Lê Mai, picture: 
// https://usc1.contabostorage.com/13613fb2865f403fab68fe1b13046c49:sonat-bi-hrm/default/1693277032418-dino__Small.png,
//  pictureKey: null, positionId: null}}

class DetailedGroup {
  String id;
  String name;
  List<MemberGroup> memberGroups;

  DetailedGroup({
    required this.id,
    required this.name,
    required this.memberGroups,
  });

  factory DetailedGroup.fromJson(Map<String, dynamic> json) {
    return DetailedGroup(
      id: json['id'],
      name: json['name'],
      memberGroups: (json['memberGroups'] as List)
          .map((item) => MemberGroup.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
