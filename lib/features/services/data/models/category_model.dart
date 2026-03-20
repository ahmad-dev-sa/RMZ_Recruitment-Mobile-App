import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    super.iconUrl,
    required super.workflowType,
    required super.isNew,
    required super.textIsNewAr,
    required super.textIsNewEn,
    required super.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      iconUrl: json['icon_url'] as String?,
      workflowType: json['workflow_type'] as String? ?? 'recruitment',
      isNew: json['is_new'] as bool? ?? false,
      textIsNewAr: json['text_is_new_ar'] as String? ?? 'جديد',
      textIsNewEn: json['text_is_new_en'] as String? ?? 'New',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
