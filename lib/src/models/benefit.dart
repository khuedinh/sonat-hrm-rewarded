import 'package:sonat_hrm_rewarded/src/utils/date_time.dart';

enum BenefitType { exchangable, nonExchangable }

class BenefitResponse {
  List<BenefitData> data;
  int page;
  int pageSize;
  int totalCount;
  int totalPages;

  BenefitResponse({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  BenefitResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null
            ? [...json['data'].map((item) => BenefitData.fromJson(item))]
            : [],
        page = json['page'],
        pageSize = json['pageSize'],
        totalCount = json['totalCount'],
        totalPages = json['totalPages'];
}

class BenefitData {
  String id;
  String name;
  String description;
  String type;
  int exchangePrice;
  bool? isPinned;
  int inStock;
  bool? active;
  String? iconUrl;
  String? iconKey;
  List<Thumbnail> thumbnails;
  String? createdAt;
  String? createdBy;
  String? lastModifiedAt;
  String? lastModifiedBy;
  String? categoryId;

  BenefitData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.exchangePrice,
    this.isPinned,
    required this.inStock,
    this.active,
    this.iconUrl,
    this.iconKey,
    required this.thumbnails,
    this.createdAt,
    this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
    this.categoryId,
  });

  BenefitData.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        name = json['name'] ?? "",
        description = json['description'] ?? "",
        type = json['type'] ?? "",
        exchangePrice = json['exchangePrice'] ?? 0,
        isPinned = json['isPinned'] ?? false,
        inStock = json['inStock'] ?? 0,
        active = json['active'] ?? true,
        iconUrl = json['iconUrl'] ?? "",
        iconKey = json['iconKey'] ?? "",
        thumbnails = json['thumbnails'] != null
            ? [...json['thumbnails'].map((item) => Thumbnail.fromJson(item))]
            : [],
        createdAt = json['createdAt'] ?? "",
        createdBy = json['createdBy'] ?? "",
        lastModifiedAt = json['lastModifiedAt'] ?? "",
        lastModifiedBy = json['lastModifiedBy'] ?? "",
        categoryId = json['categoryId'] ?? "";
}

class Thumbnail {
  String id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String imageUrl;
  String imageKey;
  bool isPrimary;

  Thumbnail({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.imageUrl,
    required this.imageKey,
    required this.isPrimary,
  });

  Thumbnail.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        deletedAt = json['deletedAt'],
        imageUrl = json['imageUrl'] ?? "",
        imageKey = json['imageKey'] ?? "",
        isPrimary = json['isPrimary'] ?? false;
}

class MyClaimResponse {
  List<ClaimedBenefit> readyToUse = [];
  List<ClaimedBenefit> archivedBox = [];

  MyClaimResponse({
    required this.readyToUse,
    required this.archivedBox,
  });

  MyClaimResponse.fromJson(Map<String, dynamic> json)
      : readyToUse = json['ready_to_use'] != null
            ? [
                ...json['ready_to_use']
                    .map((item) => ClaimedBenefit.fromJson(item))
              ]
            : [],
        archivedBox = json['archived_box'] != null
            ? [
                ...json['archived_box']
                    .map((item) => ClaimedBenefit.fromJson(item))
              ]
            : [];
}

class ClaimedBenefit {
  String id;
  String employeeEmail;
  String benefitId;
  String createdAt;
  String status;
  String code;
  String qrCode;
  bool isUsed;
  String validUntil;
  BenefitData benefit;

  ClaimedBenefit({
    required this.id,
    required this.employeeEmail,
    required this.benefitId,
    required this.createdAt,
    required this.status,
    required this.code,
    required this.qrCode,
    required this.isUsed,
    required this.validUntil,
    required this.benefit,
  });

  ClaimedBenefit.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        employeeEmail = json['employeeEmail'] ?? "",
        benefitId = json['benefitId'] ?? "",
        createdAt = json['createdAt'] ?? "",
        status = json['status'] ?? "",
        code = json['code'] ?? "",
        qrCode = json['qrCode'] ?? "",
        isUsed = json['isUsed'] ?? false,
        validUntil = json['validUntil'] ?? "",
        benefit = BenefitData.fromJson(json['benefit']);

  String get formattedCreatedAt {
    return formatDate(parseDate(createdAt));
  }
}
