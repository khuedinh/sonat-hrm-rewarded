class CategoryResponse {
  String id;
  String name;
  String description;
  String imageUrl;
  String? imageKey;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CategoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.imageKey,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  CategoryResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        deletedAt = json['deletedAt'],
        name = json['name'],
        imageUrl = json['imageUrl'],
        imageKey = json['imageKey'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['imageKey'] = imageKey;
    data['description'] = description;

    return data;
  }
}
