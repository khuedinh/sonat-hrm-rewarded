import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

String generateMessage(TransactionHistoryData transactionHistory) {
  if (transactionHistory.type == TransactionType.gain) {
    if (transactionHistory.event == TransactionEvent.update) {
      return "Admin updated your ${transactionHistory.currency.toString().split('.').last} balance.";
    }

    if (transactionHistory.event == TransactionEvent.allocate) {
      return "You have been allocated <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
    }

    if (transactionHistory.event == TransactionEvent.recognition) {
      return "You have been recognized by <b>${transactionHistory.source!.name}</b> with <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
    }
  }

  if (transactionHistory.type == TransactionType.lose) {
    if (transactionHistory.event == TransactionEvent.recognition) {
      return "You recognized <b>${transactionHistory.sink!.map((item) => item.name).join(", ")}</b> with <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
    }
    if (transactionHistory.event == TransactionEvent.redeem_benefit) {
      return "You redeemed <b>${transactionHistory.description}</b> with <b>${formatNumber(transactionHistory.amount)} ${transactionHistory.currency.toString().split('.').last}</b>.";
    }
  }

  return "";
}
