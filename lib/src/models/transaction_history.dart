import 'dart:convert';

enum TransactionType { gain, lose }

// ignore: constant_identifier_names
enum TransactionEvent { allocate, recognition, redeem_benefit, update }

enum CurrencyType { points, coins }

class TransactionHistoryResponse {
  List<TransactionHistoryData> data;
  int? page;
  int? pageSize;
  int? totalCount;
  int? totalPages;

  TransactionHistoryResponse({
    required this.data,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
  });

  TransactionHistoryResponse.fromJson(Map<String, dynamic> json)
      : data = <TransactionHistoryData>[], // Initialize the 'data' field
        page = json['page'],
        pageSize = json['pageSize'],
        totalCount = json['totalCount'],
        totalPages = json['totalPages'] {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(TransactionHistoryData.fromJson(v));
      });
    }
  }
}

class TransactionHistoryData {
  String id;
  String createdAt;
  String? updatedAt;
  String? deletedAt;
  CurrencyType currency;
  int amount;
  int endingBalance;
  TransactionType type;
  TransactionEvent event;
  String description;
  Source? source;
  List<Sink>? sink;
  String? employeeEmail;
  String? fromEmail;
  String? toEmail;

  TransactionHistoryData({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.currency,
    required this.amount,
    required this.endingBalance,
    required this.type,
    required this.event,
    required this.description,
    this.source,
    this.sink,
    this.employeeEmail,
    this.fromEmail,
    this.toEmail,
  });

  TransactionHistoryData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        deletedAt = json['deletedAt'],
        currency = CurrencyType.values.byName(json['currency']),
        amount = json['amount'] is String
            ? int.tryParse(json['amount']) ?? 0
            : json['amount'],
        endingBalance = json['endingBalance'] is String
            ? int.tryParse(json['endingBalance']) ?? 0
            : json['endingBalance'],
        type = TransactionType.values.byName(json['type']),
        event = TransactionEvent.values.byName(json['event']),
        description = json['description'],
        source = json['source'] is String
            ? Source.fromJson(jsonDecode(json['source']) ?? {})
            : Source.fromJson(json['source'] ?? {}),
        sink = json['sink'] is String
            ? List<Sink>.from(
                (jsonDecode(json['sink']) ?? []).map((v) => Sink.fromJson(v)))
            : List<Sink>.from(json['sink'].map((v) => Sink.fromJson(v))),
        employeeEmail = json['employeeEmail'],
        fromEmail = json['fromEmail'],
        toEmail = json['toEmail'];
}

class Source {
  String? id;
  String? name;
  String? email;
  String? picture;
  String? createdAt;
  String? deletedAt;
  String? updatedAt;
  String? pictureKey;
  String? positionId;

  Source({
    this.id,
    this.name,
    this.email,
    this.picture,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
    this.pictureKey,
    this.positionId,
  });

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    picture = json['picture'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    updatedAt = json['updatedAt'];
    pictureKey = json['pictureKey'];
    positionId = json['positionId'];
  }
}

class Sink {
  String? id;
  String? name;
  String? email;
  int? amount;
  String? picture;
  String? createdAt;
  String? deletedAt;
  String? updatedAt;
  String? pictureKey;
  String? positionId;
  int? endingBalance;

  Sink({
    this.id,
    this.name,
    this.email,
    this.amount,
    this.picture,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
    this.pictureKey,
    this.positionId,
    this.endingBalance,
  });

  Sink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    amount = json['amount'];
    picture = json['picture'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    updatedAt = json['updatedAt'];
    pictureKey = json['pictureKey'];
    positionId = json['positionId'];
    endingBalance = json['endingBalance'];
  }
}
