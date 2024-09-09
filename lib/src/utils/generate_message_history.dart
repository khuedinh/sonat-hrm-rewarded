import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

String generateMessage(
    TransactionHistoryData transactionHistory, BuildContext context) {
  if (transactionHistory.type == TransactionType.gain) {
    if (transactionHistory.event == TransactionEvent.update) {
      return transactionHistory.currency.toString().split('.').last == "points"
          ? AppLocalizations.of(context)!.admin_updated_point
          : AppLocalizations.of(context)!.admin_updated_coin;
    }

    if (transactionHistory.event == TransactionEvent.allocate) {
      return "${AppLocalizations.of(context)!.you_have_been_allocated} <b>${formatNumber(transactionHistory.amount)} ${AppLocalizations.of(context)!.points}</b>.";
    }

    if (transactionHistory.event == TransactionEvent.recognition) {
      return "${AppLocalizations.of(context)!.you_have_been_recognized_by} <b>${transactionHistory.source!.name}</b> ${AppLocalizations.of(context)!.with_key} <b>${formatNumber(transactionHistory.amount)} ${AppLocalizations.of(context)!.coins}</b>.";
    }
  }

  if (transactionHistory.type == TransactionType.lose) {
    if (transactionHistory.event == TransactionEvent.recognition) {
      return "${AppLocalizations.of(context)!.you_recognized} <b>${transactionHistory.sink!.map((item) => item.name).join(", ")}</b> ${AppLocalizations.of(context)!.with_key} <b>${formatNumber(transactionHistory.amount)} ${AppLocalizations.of(context)!.points}</b>.";
    }
    if (transactionHistory.event == TransactionEvent.redeem_benefit) {
      return "${AppLocalizations.of(context)!.you_redeemed} <b>${transactionHistory.description}</b> with <b>${formatNumber(transactionHistory.amount)} ${AppLocalizations.of(context)!.coins}</b>.";
    }
  }

  return "";
}
