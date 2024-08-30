import 'package:sonat_hrm_rewarded/src/models/transaction_history.dart';

class NotificationListRes {
  List<NotificationData>? data;
  int? page;
  int? pageSize;
  int? totalCount;
  int? totalPages;

  NotificationListRes(
      {this.data, this.page, this.pageSize, this.totalCount, this.totalPages});

  NotificationListRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    page = json['page'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['totalPages'] = totalPages;
    return data;
  }
}

class NotificationData {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isRead;
  String? employeeEmail;
  TransactionHistoryData? transactionHistory;

  NotificationData(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isRead,
      this.employeeEmail,
      this.transactionHistory});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    isRead = json['isRead'];
    employeeEmail = json['employeeEmail'];
    transactionHistory = json['transactionHistory'] != null
        ? TransactionHistoryData.fromJson(json['transactionHistory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['isRead'] = isRead;
    data['employeeEmail'] = employeeEmail;
    // if (transactionHistory != null) {
    //   data['transactionHistory'] = transactionHistory!.toJson();
    // }
    return data;
  }
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

  Source(
      {this.id,
      this.name,
      this.email,
      this.picture,
      this.createdAt,
      this.deletedAt,
      this.updatedAt,
      this.pictureKey,
      this.positionId});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['picture'] = picture;
    data['createdAt'] = createdAt;
    data['deletedAt'] = deletedAt;
    data['updatedAt'] = updatedAt;
    data['pictureKey'] = pictureKey;
    data['positionId'] = positionId;
    return data;
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

  Sink(
      {this.id,
      this.name,
      this.email,
      this.amount,
      this.picture,
      this.createdAt,
      this.deletedAt,
      this.updatedAt,
      this.pictureKey,
      this.positionId,
      this.endingBalance});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['amount'] = amount;
    data['picture'] = picture;
    data['createdAt'] = createdAt;
    data['deletedAt'] = deletedAt;
    data['updatedAt'] = updatedAt;
    data['pictureKey'] = pictureKey;
    data['positionId'] = positionId;
    data['endingBalance'] = endingBalance;
    return data;
  }
}

class UnreadNotiRes {
  int? count;

  UnreadNotiRes({this.count});

  UnreadNotiRes.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}
