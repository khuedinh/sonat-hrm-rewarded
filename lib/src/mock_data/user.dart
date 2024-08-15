import 'package:sonat_hrm_rewarded/src/models/user.dart';

const currentUser = User(
  id: "u1",
  name: "Sonat BI Team",
  email: "bi.sonat@sonat.vn",
  coin: 2000,
  point: 3000,
);

const listLeaderboard = [
  currentUser,
  User(
    id: "u2",
    name: "John Weed",
    email: "john.weed@sonat.vn",
    coin: 1500,
    point: 3000,
  ),
  User(
    id: "u3",
    name: "Dinh Ngoc Khue",
    email: "khuedn@sonat.vn",
    coin: 1000,
    point: 3000,
  ),
  User(
    id: "u4",
    name: "Vu Le Mai",
    email: "maivl@sonat.vn",
    coin: 500,
    point: 3000,
  ),
  User(
    id: "u5",
    name: "Do Duc Long",
    email: "longdd@sonat.vn",
    coin: 200,
    point: 3000,
  ),
];
