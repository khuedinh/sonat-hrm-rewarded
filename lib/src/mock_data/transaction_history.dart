import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';

final listPointTransactions = [
  TransactionHistory(
    id: 't0',
    content: "Recognized Sonat BI Team 2 with 500 points",
    createdAt: DateTime(2024, 08, 15, 15, 13, 22),
    currentBalance: 2000,
    previousBalance: 2500,
  ),
  TransactionHistory(
    id: 't1',
    content: "Received 1000 points from admin",
    createdAt: DateTime(2024, 08, 15, 10, 23, 52),
    currentBalance: 2500,
    previousBalance: 1500,
  ),
  TransactionHistory(
    id: 't2',
    content: "Received 200 points from system",
    createdAt: DateTime(2024, 08, 13, 15, 13, 22),
    currentBalance: 1500,
    previousBalance: 1300,
  ),
  TransactionHistory(
    id: 't3',
    content: "Received 500 points from admin",
    createdAt: DateTime(2024, 08, 13, 15, 15, 22),
    currentBalance: 1300,
    previousBalance: 800,
  ),
  TransactionHistory(
    id: 't4',
    content: "Recognized Sonat BI Team 2 with 200 points",
    createdAt: DateTime(2024, 08, 12, 09, 34, 22),
    currentBalance: 800,
    previousBalance: 1000,
  ),
  TransactionHistory(
    id: 't5',
    content: "Received 1000 points from system",
    createdAt: DateTime(2024, 08, 10, 22, 10, 11),
    currentBalance: 1000,
    previousBalance: 0,
  ),
];

final listCoinTransactions = [
  TransactionHistory(
    id: 't0',
    content: "Receive 100 coins from admin",
    createdAt: DateTime(2024, 08, 15, 15, 13, 22),
    currentBalance: 1000,
    previousBalance: 900,
  ),
  TransactionHistory(
    id: 't1',
    content: "Redeem Sonat Uniform 2024 with 100 coins",
    createdAt: DateTime(2024, 08, 14, 17, 48, 52),
    currentBalance: 900,
    previousBalance: 1000,
  ),
  TransactionHistory(
    id: 't2',
    content: "Received 500 coins from system",
    createdAt: DateTime(2024, 08, 13, 15, 13, 22),
    currentBalance: 1000,
    previousBalance: 500,
  ),
  TransactionHistory(
    id: 't3',
    content: "Received 500 coins from Sonat BI Team 2",
    createdAt: DateTime(2024, 08, 13, 15, 15, 22),
    currentBalance: 500,
    previousBalance: 0,
  ),
  TransactionHistory(
    id: 't4',
    content: "Redeem secret box with 500 coins",
    createdAt: DateTime(2024, 08, 12, 09, 34, 22),
    currentBalance: 0,
    previousBalance: 500,
  ),
  TransactionHistory(
    id: 't5',
    content: "Received 500 coins from system",
    createdAt: DateTime(2024, 08, 11, 22, 10, 11),
    currentBalance: 500,
    previousBalance: 0,
  ),
];
