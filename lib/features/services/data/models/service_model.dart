import '../../../../core/enums/workflow_type.dart';
import '../../domain/entities/service_entity.dart';
import 'category_model.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    super.imageUrl,
    required super.price,
    required super.isActive,
    super.category,
    super.workflowType,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      price: json['price']?.toString() ?? '0.00',
      isActive: json['is_active'] as bool? ?? true,
      category: json['category'] != null 
          ? CategoryModel.fromJson(json['category']) 
          : null,
      workflowType: json['workflow_type'] != null 
          ? WorkflowType.fromString(json['workflow_type'] as String?)
          : null,
    );
  }
}
