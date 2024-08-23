enum BenefitType { exchangable, nonExchangable }

class Benefit {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;
  final BenefitType type;
  final bool? isFeatured;
  final int stock;
  final int exchanged;
  final bool? isClaimed;
  final bool? isUsed;

  const Benefit({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
    required this.exchanged,
    this.isFeatured = false,
    this.type = BenefitType.exchangable,
    this.isClaimed = false,
    this.isUsed = false,
  });
}

class BenefitResponse {
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
  List<String> imageUrls;
  List<String> imageKeys;
  String? createdAt;
  String? createdBy;
  String? lastModifiedAt;
  String? lastModifiedBy;
  String? categoryId;

  BenefitResponse({
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
    required this.imageUrls,
    required this.imageKeys,
    this.createdAt,
    this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
    this.categoryId,
  });

  BenefitResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        name = json['name'] ?? "",
        description = json['description'] ?? "",
        type = json['type'] ?? "",
        exchangePrice = json['exchangePrice'] ?? "",
        isPinned = json['isPinned'],
        inStock = json['inStock'] ?? 0,
        active = json['active'],
        iconUrl = json['iconUrl'],
        iconKey = json['iconKey'],
        imageUrls = json['imageUrls'].cast<String>() ?? [],
        imageKeys = json['imageKeys'].cast<String>() ?? [],
        createdAt = json['createdAt'],
        createdBy = json['createdBy'],
        lastModifiedAt = json['lastModifiedAt'],
        lastModifiedBy = json['lastModifiedBy'],
        categoryId = json['categoryId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['exchangePrice'] = exchangePrice;
    data['isPinned'] = isPinned;
    data['inStock'] = inStock;
    data['active'] = active;
    data['iconUrl'] = iconUrl;
    data['iconKey'] = iconKey;
    data['imageUrls'] = imageUrls;
    data['imageKeys'] = imageKeys;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    data['lastModifiedAt'] = lastModifiedAt;
    data['lastModifiedBy'] = lastModifiedBy;
    data['categoryId'] = categoryId;
    return data;
  }
}
