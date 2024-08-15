enum BenefitType { gift, card }

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
    this.type = BenefitType.gift,
    this.isClaimed = false,
    this.isUsed = false,
  });
}
