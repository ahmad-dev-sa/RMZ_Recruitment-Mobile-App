class CategoryEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? iconUrl;
  final String workflowType;
  final bool isNew;
  final String textIsNewAr;
  final String textIsNewEn;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.iconUrl,
    required this.workflowType,
    required this.isNew,
    required this.textIsNewAr,
    required this.textIsNewEn,
    required this.isActive,
  });
}
