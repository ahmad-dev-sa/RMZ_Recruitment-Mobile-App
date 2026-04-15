import '../../../../core/enums/workflow_type.dart';
import 'category_entity.dart';

class ServiceEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? imageUrl;
  final String price;
  final bool isActive;
  final CategoryEntity? category;
  final WorkflowType? workflowType;

  const ServiceEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.imageUrl,
    required this.price,
    required this.isActive,
    this.category,
    this.workflowType,
  });
}
